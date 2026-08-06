extends CharacterBody2D

@export var speed: float = 150.0
@export var acceleration: float = 1200.0
@export var friction: float = 1000.0

func _physics_process(delta: float) -> void:
	
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
