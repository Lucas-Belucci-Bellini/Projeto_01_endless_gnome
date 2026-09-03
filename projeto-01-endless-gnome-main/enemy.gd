# RESPONSABILIDADE:
# Controlar o inimigo do protótipo top-down: localizar jogador, perseguir,
# atacar, receber dano e aplicar knockback.
#
# DEPENDÊNCIAS:
# Player.instance e AnimatedSprite2D.
#
# RISCOS CONHECIDOS:
# - acoplamento direto com Player.instance;
# - ataque chama Player.take_damage diretamente;
# - IA, combate, vida e morte estão no mesmo script;
# - ausência de evento de morte/recompensa;
# - contrato de dano precisa permanecer compatível com o restante do projeto.
#
# STATUS:
# PROTOTYPE.

extends CharacterBody2D

# Configurações de movimento, vida e dano do protótipo.
# TODO: migrar balanceamento para dados quando a arquitetura de conteúdo existir.
@export var speed := 80
@export var max_health := 3
@export var damage := 1

# Temporização do ataque.
@export var attack_cooldown := 1.0
@export var attack_pause := 1.0

# Reação a dano.
@export var invulnerability_time := 0.4
@export var knockback_force := 500

var health := 0
var player = null

# Estado interno de movimento/combate.
var knockback_velocity := Vector2.ZERO
var can_attack := true
var can_take_damage := true
var is_attacking := false

# RISCO: caminho fixo. Deve existir AnimatedSprite2D na cena Enemy.
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	# Inicializa vida máxima.
	health = max_health

func _physics_process(_delta):
	# Localiza o jogador via singleton estático atual.
	# RISCO: se o player não estiver pronto, o inimigo simplesmente retorna.
	if player == null:
		player = Player.instance
	if player == null:
		return

	# Vetor do inimigo em direção ao jogador.
	var direction = player.global_position - global_position
	var distance = direction.length()

	if is_attacking:
		# Durante a pausa do ataque, usa somente o knockback existente.
		velocity = knockback_velocity
	else:
		# Persegue enquanto não estiver suficientemente perto.
		if distance > 10:
			direction = direction.normalized()
			velocity = direction * speed
		else:
			velocity = Vector2.ZERO

	# Aplica knockback adicional ao movimento normal.
	velocity += knockback_velocity
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, 0.08)

	move_and_slide()

	# Ataque é disparado por distância e cooldown.
	# TEST: validar se o inimigo consegue atacar através de obstáculos;
	# atualmente não existe teste de linha de visão.
	if distance < 45 and can_attack and not is_attacking:
		attack()

func attack():
	# Não existe alvo sem referência de player.
	if player == null:
		return

	can_attack = false
	is_attacking = true

	# CONTRATO: espera-se que Player implemente take_damage(amount, attacker_pos).
	# RISCO: esse acoplamento deve ser substituído por HitBox/DamageData.
	player.take_damage(damage, global_position)

	# Pausa visual/lógica do ataque.
	await get_tree().create_timer(attack_pause).timeout
	is_attacking = false

	# Tempo até próximo ataque.
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

# CONTRATO ATUAL: take_damage(amount, attacker_pos).
func take_damage(amount: int, attacker_pos: Vector2):
	# Evita processamento de múltiplos impactos durante invulnerabilidade.
	if not can_take_damage:
		return

	can_take_damage = false

	health -= amount
	flash()

	# Knockback para longe da origem do impacto.
	# TEST: confirmar comportamento para atacante no mesmo ponto.
	var dir = (global_position - attacker_pos).normalized()
	knockback_velocity = dir * knockback_force

	if health <= 0:
		# TODO: morte formal, drops/recompensas e sinal died.
		queue_free()

	await get_tree().create_timer(invulnerability_time).timeout
	can_take_damage = true

func flash():
	# Feedback visual temporário de dano.
	sprite.modulate = Color(5,5,5)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1,1,1)
