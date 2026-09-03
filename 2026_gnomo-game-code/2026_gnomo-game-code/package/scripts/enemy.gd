# RESPONSABILIDADE:
# Controlar o inimigo da implementação antiga de plataforma 2D.
#
# DEPENDÊNCIAS:
# HitBox e Timer na árvore da cena. O alvo do ataque precisa pertencer ao grupo
# `player` e expor `take_hit()`.
#
# STATUS:
# LEGACY/PROTOTYPE.
#
# RISCOS:
# - não possui vida/dano real;
# - alterna direção apenas por Timer;
# - ataque remove/afeta o jogador diretamente via take_hit();
# - é uma segunda classe `Enemy`, diferente da linha top-down.

extends CharacterBody2D
class_name Enemy

# Parâmetros do protótipo de plataforma.
const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const FALL_VELOCITY = 600.0

var gravity = ProjectSettings.get("physics/2d/default_gravity")

# Nós esperados na cena.
@onready var hit_box := $HitBox
@onready var timer := $Timer

# 1 = direita, -1 = esquerda.
var direction := 1.0

func _ready() -> void:
	# Inverte o sentido sempre que o Timer dispara.
	timer.timeout.connect(_moveToward)

func _physics_process(delta: float) -> void:
	# Aplica gravidade e movimento horizontal continuamente.
	free_fall(delta)

	if direction:
		velocity.x = direction * SPEED

	move_and_slide()

func _moveToward():
	# Patrulha básica: alterna o sinal da direção.
	direction *= -1.0

func free_fall(delta: float) -> void:
	# Limita a velocidade de queda.
	if not is_on_floor():
		velocity.y = minf(FALL_VELOCITY, velocity.y + (gravity * 2) * delta)

func _on_hit_box_body_entered(body: Node2D) -> void:
	# Ataque do protótipo antigo: chama diretamente a reação do jogador.
	# TEST: confirmar se a conexão do sinal existe na cena usada.
	if body.is_in_group("player"):
		body.take_hit()
