# RESPONSABILIDADE:
# Controlar a entidade do jogador na implementação top-down/protótipo.
# Atualmente concentra movimento, animação, ataque, vida, dano e knockback.
#
# DEPENDÊNCIAS:
# AnimatedSprite2D, ItemPosition/WeaponHandler/HitBox e InputMap.
#
# CONTRATO:
# O Player movimenta-se, ataca e recebe dano. A IA atual pode localizar
# o jogador através de Player.instance.
#
# RISCOS CONHECIDOS:
# - Player.instance cria acoplamento global.
# - caminhos $... dependem exatamente da árvore da cena.
# - take_damage usa dois argumentos e deve ser compatível com HurtBox.
# - queue_free() ainda substitui o fluxo formal de morte/respawn.
#
# STATUS:
# PROTOTYPE / CANDIDATO A IMPLEMENTAÇÃO OFICIAL.

class_name Player
extends CharacterBody2D

# Configurações de movimento, vida e dano.
# TODO: separar dados de balanceamento da lógica quando o sistema de dados existir.
@export var speed := 150
@export var max_health := 5
@export var damage := 1

# Controle temporal do ataque e da invulnerabilidade.
@export var attack_cooldown := 0.3
@export var invulnerability_time := 0.5
@export var knockback_force := 700

# Estado interno do jogador.
var health := 0
var attacking := false
var can_attack := true
var can_take_damage := true

# Velocidade adicional enquanto o jogador sofre knockback.
var knockback_velocity := Vector2.ZERO

# RISCO: referências acopladas à árvore da cena.
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $ItemPosition/WeaponHandler/HitBox

# RISCO: referência global usada pelo Enemy. Precisa ser substituída
# por comunicação mais desacoplada quando a arquitetura for consolidada.
static var instance = null

func _ready():
	# Registra a instância atual para sistemas que ainda dependem dela.
	# TEST: validar comportamento ao destruir/recriar a cena do jogador.
	instance = self

	# Vida começa no valor máximo configurado.
	health = max_health

func _physics_process(_delta):
	var direction = Vector2.ZERO

	# Captura input digital nos quatro eixos.
	# TEST: confirmar que estas ações existem na configuração do projeto oficial.
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	# Normaliza para impedir velocidade diagonal maior.
	if direction != Vector2.ZERO:
		direction = direction.normalized()

	# Movimento produzido pelo input.
	velocity = direction * speed

	# Soma o deslocamento temporário de knockback.
	velocity += knockback_velocity

	# Reduz gradualmente o knockback.
	# TEST: confirmar se esse fator apresenta comportamento consistente em runtime.
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 0.08)

	move_and_slide()

	# Atualiza a animação de acordo com a direção do movimento.
	update_animation(direction)

func update_animation(direction):
	# Sem movimento, usa animação default.
	if direction == Vector2.ZERO:
		sprite.play("default")
		return

	# Escolhe a animação pelo eixo dominante.
	if abs(direction.x) > abs(direction.y):
		sprite.play("walking_right" if direction.x > 0 else "walking_left")
	else:
		sprite.play("walking_up" if direction.y < 0 else "walking_down")

func _process(_delta):
	# Entrada de ataque baseada em clique.
	# TEST: confirmar que a HitBox possui a configuração de colisão esperada.
	if Input.is_action_just_pressed("mouse_click") and can_attack:
		attack()

func attack():
	# Bloqueia novo ataque durante o cooldown.
	can_attack = false
	attacking = true

	# Consulta áreas atualmente sobrepostas pela HitBox da arma.
	# RISCO: o método pressupõe que cada área relevante possa chegar ao alvo
	# através de get_parent(). Isso é uma convenção estrutural frágil.
	var areas = hitbox.get_overlapping_areas()

	for area in areas:
		var target = area.get_parent()

		# O alvo precisa expor a API take_damage.
		if target != self and target.has_method("take_damage"):
			# Contrato atual: dano + posição do atacante.
			target.take_damage(damage, global_position)

	# Aguarda o cooldown antes de liberar outro ataque.
	await get_tree().create_timer(attack_cooldown).timeout

	attacking = false
	can_attack = true

# CONTRATO ATUAL:
# take_damage(amount, attacker_pos)
#
# BUG/RISCO: HurtBox.gd atualmente chama esse método com apenas um argumento.
# Referência: EG-AUD-003. Não corrigir aqui durante a primeira passagem de
# instrumentação, para manter a evidência separada da correção.
func take_damage(amount: int, attacker_pos: Vector2):
	# Evita múltiplos danos durante a janela de invulnerabilidade.
	if not can_take_damage:
		return

	can_take_damage = false

	health -= amount
	flash()

	# Calcula a direção oposta à origem do impacto.
	# TEST: attacker_pos igual a global_position deve ser tratado de forma definida.
	var dir = (global_position - attacker_pos).normalized()
	knockback_velocity = dir * knockback_force

	if health <= 0:
		# TODO: substituir por fluxo formal de morte, animação, checkpoint/respawn
		# e transição de estado. Atualmente remove a entidade.
		queue_free()

	# Janela de invulnerabilidade depois do dano.
	await get_tree().create_timer(invulnerability_time).timeout
	can_take_damage = true

func flash():
	# Feedback visual temporário após receber dano.
	# TEST: confirmar comportamento quando vários efeitos ocorrerem próximos.
	sprite.modulate = Color(5,5,5)

	await get_tree().create_timer(0.1).timeout

	sprite.modulate = Color(1,1,1)
