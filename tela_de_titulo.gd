# RESPONSABILIDADE:
# Controlar a tela inicial do jogo.
#
# FLUXO ESPERADO:
# Jogar -> Level; Configurações -> submenu; Sair -> encerra aplicação.
#
# RISCOS:
# - `_ready` e `_process` vazios são código de placeholder;
# - transição de cena depende de `res://level.tscn` existir no mesmo projeto;
# - configurações são instanciadas localmente sem um controlador de UI;
# - não existe tratamento de erro para troca de cena.
#
# STATUS:
# PROTOTYPE.

extends Control

func _ready() -> void:
	# PLACEHOLDER: nenhuma inicialização da tela é necessária atualmente.
	# TODO: definir foco inicial, acessibilidade e estado inicial dos botões.
	pass

func _process(delta: float) -> void:
	# PLACEHOLDER: não há lógica por frame na tela inicial atualmente.
	# TODO: remover o método caso não seja necessário.
	# Observação: `delta` não é utilizado.
	pass

func _on_jogar_button_pressed() -> void:
	# Troca para a cena de jogo definida pelo protótipo.
	# TEST: validar existência da cena e se ela é realmente a Level oficial.
	get_tree().change_scene_to_file("res://level.tscn")

func _on_config_button_pressed() -> void:
	# Instancia o menu de configurações como filho da tela de título.
	# RISCO: o submenu fica dependente da instância atual da tela inicial.
	var cena_config = preload("res://menu_config.tscn")
	var menu_instancia = cena_config.instantiate()
	add_child(menu_instancia)

func _on_sair_button_pressed() -> void:
	# Solicita o encerramento da aplicação.
	get_tree().quit()
