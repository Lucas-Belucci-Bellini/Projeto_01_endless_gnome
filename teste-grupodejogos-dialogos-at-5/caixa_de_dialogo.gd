extends Node2D

@onready var sprite_rosto = $Sprite_Rosto
@onready var rich_text_label = $RichTextLabel

func _ready() -> void:
	hide() 

# Função simples para mostrar o diálogo
func falar(texto: String) -> void:
	rich_text_label.text = texto
	show() # Fica visível

# Função para fechar (quando você quiser controlar pelo input do NPC/Player)
func fechar() -> void:
	hide()
