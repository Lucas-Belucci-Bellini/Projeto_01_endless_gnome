extends CharacterBody2D

var player_perto: bool = false
var player_ref: CharacterBody2D = null
var caixa_instancia: Node2D = null

@onready var npc_sprite = $Sprite2D

var cena_caixa = preload("res://entities/caixa_de_dialogo.tscn")
@export var offset_abaixo_player: Vector2 = Vector2(0, 320)

func _process(_delta: float) -> void:
	if player_perto and Input.is_action_just_pressed("ui_accept"):
		if caixa_instancia == null:
			caixa_instancia = cena_caixa.instantiate()
			get_parent().add_child(caixa_instancia)
			caixa_instancia.falar("Olá! Esta caixa está logo abaixo de você.")
			
			if player_ref != null:
				player_ref.velocity = Vector2.ZERO
				player_ref.set_physics_process(false)
		
		else:
			fechar_dialogo()

	if caixa_instancia != null and player_ref != null:
		caixa_instancia.global_position = player_ref.global_position + offset_abaixo_player

func fechar_dialogo() -> void:
	if caixa_instancia != null:
		caixa_instancia.queue_free()
		caixa_instancia = null
	
	if player_ref != null:
		player_ref.set_physics_process(true)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = true
		player_ref = body as CharacterBody2D
		print("Player entrou na área!")
		npc_sprite.flip_v = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_perto = false
		print("Player saiu da área!")
		npc_sprite.flip_v = false
		
		fechar_dialogo()
		player_ref = null
