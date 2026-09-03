# RESPONSABILIDADE:
# Controlar o submenu de configurações atualmente existente.
#
# DEPENDÊNCIAS:
# menu_config.tscn.
#
# ESTADO ATUAL:
# O botão de voltar fecha esta instância. A interface possui opções de volume
# e SFX, mas ainda não existe implementação dessas configurações neste script.
#
# RISCOS:
# - `menu_config` é pré-carregado, porém não é usado pela função pública;
# - abrir configurações dentro de outro menu sem um controlador central pode
#   gerar árvores de UI aninhadas;
# - áudio ainda não possui um contrato global.
#
# STATUS:
# PROTOTYPE.

extends Control

# PRECAUÇÃO: esta variável carrega a cena, mas atualmente não é utilizada.
# TODO: remover ou utilizar quando o fluxo de configuração for consolidado.
var menu_config = preload("res://menu_config.tscn")

func abrir_configuracoes():
	# Cria outra instância do próprio menu de configurações.
	# RISCO: esta função pode gerar uma configuração aninhada se chamada a partir
	# de uma instância que já seja o menu de configurações.
	var cena_config = preload("res://menu_config.tscn")
	var menu_instancia = cena_config.instantiate()
	add_child(menu_instancia)

func _on_voltar_button_pressed() -> void:
	# Fecha somente a instância atual do menu.
	# TEST: confirmar se o menu pai permanece disponível como esperado.
	queue_free()
