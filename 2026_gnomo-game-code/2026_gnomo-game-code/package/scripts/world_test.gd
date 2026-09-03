# RESPONSABILIDADE:
# Coordenar a cena de teste da implementação antiga de plataforma.
#
# DEPENDÊNCIAS:
# A cena precisa conter `Camera` e `Gnomo` como filhos diretos.
#
# STATUS:
# LEGACY/TEST.
#
# RISCOS:
# - o nome da classe contém `WorlTest`, provavelmente um typo legado;
# - a câmera é movida manualmente para a posição do jogador a cada frame;
# - a cena é explicitamente uma cena de teste e não deve ser confundida com Level 01.

extends Node2D
class_name WorlTest

# Referências fixas aos nós da cena de teste.
@onready var camera := $Camera
@onready var gnomo_player := $Gnomo

func _ready() -> void:
	# PLACEHOLDER: nenhuma preparação do mundo de teste é necessária atualmente.
	# TODO: remover método ou documentar setup real caso a cena permaneça em uso.
	pass

func _process(_delta: float) -> void:
	# Mantém a câmera centralizada na posição atual do jogador.
	# RISCO: atualizar posição em todo frame pode ser substituído pelo recurso
	# de follow da Camera2D na implementação oficial.
	camera.position = gnomo_player.global_position
