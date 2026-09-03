# RESPONSABILIDADE:
# Inicializar e, no futuro, coordenar o cenário do protótipo.
#
# DEPENDÊNCIAS:
# Espera nós `TileMap` e `Decoration` diretamente na cena pai.
#
# RISCO CRÍTICO DE MANUTENÇÃO:
# `setup_world()` ainda é um placeholder. As referências @onready também
# falharão se os nós esperados não existirem na árvore da cena.
#
# STATUS:
# PROTOTYPE / PLACEHOLDER.

extends Node2D

# RISCO: caminhos fixos na árvore da cena.
@onready var tilemap: TileMap = $TileMap
@onready var decoration: Node2D = $Decoration

func _ready():
	# Log simples usado para confirmar que o cenário foi inicializado.
	# TODO: substituir por logging/debug configurável quando necessário.
	print("Cenário carregado")

	# Ponto de entrada da preparação do mundo.
	setup_world()

func setup_world():
	# PLACEHOLDER: nenhum processamento acontece atualmente.
	# TODO(EG-AUD-004): decidir se esta função será implementada ou removida.
	pass
