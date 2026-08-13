extends CharacterBody2D
class_name Enemy

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const FALL_VELOCITY = 600.0

var gravity = ProjectSettings.get("physics/2d/default_gravity")

@onready var hit_box := $HitBox
@onready var timer := $Timer

var direction := 1.0

func _ready() -> void:
	timer.timeout.connect(_moveToward)

func _physics_process(delta: float) -> void:	
	free_fall(delta)
	
	if direction:
		velocity.x = direction * SPEED
	
	move_and_slide()
	
func _moveToward():
	direction *= -1.0

func free_fall(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(FALL_VELOCITY, velocity.y + (gravity * 2) * delta)   # velocidade média = aceleração de gravidade * tempo
		
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_hit()
		
