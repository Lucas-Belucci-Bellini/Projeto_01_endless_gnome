extends Control

var menu_config = preload("res://menu_config.tscn")

func abrir_configuracoes():
	var cena_config = preload("res://menu_config.tscn")
	var menu_instancia = cena_config.instantiate()
	add_child(menu_instancia)


func _on_voltar_button_pressed() -> void:
	queue_free()
