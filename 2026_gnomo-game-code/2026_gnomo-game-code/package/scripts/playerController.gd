extends CharacterBody2D
class_name PlayerController

const SPEED = 400.0

const JUMP_VELOCITY = -900.0

var gravity : float = ProjectSettings.get("physics/2d/default_gravity")
const FALL_VELOCITY = 900

@onready var animation_player := $AnimationPlayer

@onready var gnome_sprite := $Visual 

@onready var jump_sound := $Jump

@onready var hit_box := $HitBox

func _physics_process(delta: float) -> void:
	
	freefall(delta)
	
	jump()
	
	direction()

	update_animation()

	move_and_slide()

func get_new_animation() -> String:
	var new_animation : String
	
	if abs(velocity.x) > 0.1:
		new_animation = "walking"  
	else:
		new_animation = "idle"
	
	return new_animation

func update_animation() -> void:
	if get_new_animation() != animation_player.current_animation:
		animation_player.play(get_new_animation())
	

func jump() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		
		
func direction() -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction > 0:
		hit_box.position.x = abs(hit_box.position.x)
		gnome_sprite.flip_h = false
	elif direction < 0 or Vector2.ZERO:
		hit_box.position.x = -abs(hit_box.position.x)
		gnome_sprite.flip_h = true
	
	
func freefall(delta: float) -> void:
	if not is_on_floor():
		velocity.y = minf(FALL_VELOCITY, velocity.y + (gravity * 2) * delta)   # velocidade média = aceleração de gravidade * tempo


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.queue_free()

		
func take_hit():
	velocity.y = lerp(position.y, 25.0, -4)
	velocity.x = lerp(velocity.x, 25.0 , -100)
	
	
