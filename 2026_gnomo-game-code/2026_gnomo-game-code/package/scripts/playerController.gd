# RESPONSABILIDADE:
# Controlar o jogador da implementação antiga de plataforma 2D.
#
# DEPENDÊNCIAS:
# AnimationPlayer, Visual, Jump e HitBox na árvore da cena.
# Usa ações `ui_accept`, `ui_left` e `ui_right`.
#
# STATUS:
# LEGACY/PROTOTYPE. Não deve receber novas features antes da decisão sobre
# qual implementação de Player será oficial.
#
# RISCOS:
# - condição `direction < 0 or Vector2.ZERO` é suspeita e precisa de teste;
# - ataque remove inimigos diretamente com queue_free();
# - take_hit mistura posição e velocidade no cálculo de knockback;
# - este Player não é o mesmo `Player` da implementação top-down.

extends CharacterBody2D
class_name PlayerController

# Constantes de movimento do protótipo de plataforma.
const SPEED = 400.0
const JUMP_VELOCITY = -900.0

# Gravidade obtida das configurações de física do projeto.
var gravity : float = ProjectSettings.get("physics/2d/default_gravity")
const FALL_VELOCITY = 900

# Referências aos nós esperados na cena.
# RISCO: qualquer mudança de nomes quebra essas referências.
@onready var animation_player := $AnimationPlayer
@onready var gnome_sprite := $Visual
@onready var jump_sound := $Jump
@onready var hit_box := $HitBox

func _physics_process(delta: float) -> void:
	# Fluxo principal de física do jogador antigo.
	freefall(delta)
	jump()
	direction()
	update_animation()
	move_and_slide()

func get_new_animation() -> String:
	# Escolhe walking quando existe movimento horizontal; idle caso contrário.
	var new_animation : String

	if abs(velocity.x) > 0.1:
		new_animation = "walking"
	else:
		new_animation = "idle"

	return new_animation

func update_animation() -> void:
	# Só troca a animação quando necessário.
	if get_new_animation() != animation_player.current_animation:
		animation_player.play(get_new_animation())

func jump() -> void:
	# Pulo só é permitido no chão.
	# TEST: validar ação ui_accept no projeto legado.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

func direction() -> void:
	# Leitura do eixo horizontal do InputMap.
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		# Desaceleração até parar.
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction > 0:
		# Coloca HitBox à direita e não espelha o sprite.
		hit_box.position.x = abs(hit_box.position.x)
		gnome_sprite.flip_h = false
	elif direction < 0 or Vector2.ZERO:
		# RISCO: `or Vector2.ZERO` é uma expressão suspeita. Deve ser investigada.
		hit_box.position.x = -abs(hit_box.position.x)
		gnome_sprite.flip_h = true

func freefall(delta: float) -> void:
	# Aplica gravidade até o limite definido.
	if not is_on_floor():
		velocity.y = minf(FALL_VELOCITY, velocity.y + (gravity * 2) * delta)

func _on_hit_box_body_entered(body: Node2D) -> void:
	# No protótipo antigo, tocar um inimigo é suficiente para removê-lo.
	# TODO: substituir por combate/dano formal se esta linha for mantida.
	if body.is_in_group("enemies"):
		body.queue_free()

func take_hit():
	# RISCO: calcula velocidade usando posição do jogador, não uma origem de
	# impacto. O resultado provavelmente não representa knockback consistente.
	# TEST: reproduzir e medir o comportamento antes de alterar.
	velocity.y = lerp(position.y, 25.0, -4)
	velocity.x = lerp(velocity.x, 25.0, -100)
