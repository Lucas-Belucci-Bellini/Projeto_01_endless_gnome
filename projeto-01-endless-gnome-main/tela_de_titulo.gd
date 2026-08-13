extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_jogar_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_config_button_pressed() -> void:
	var cena_config = preload("res://menu_config.tscn")
	var menu_instancia = cena_config.instantiate()
	add_child(menu_instancia)

func _on_sair_button_pressed() -> void:
	get_tree().quit()
