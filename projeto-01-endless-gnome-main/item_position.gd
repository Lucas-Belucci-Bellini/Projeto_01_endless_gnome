# RESPONSABILIDADE:
# Posicionar o item/arma do jogador ao redor do personagem conforme a posição
# do mouse e orientar sua rotação.
#
# DEPENDÊNCIAS:
# O pai precisa fornecer global_position válida. A cena precisa manter este
# nó como filho direto do elemento que representa o jogador.
#
# RISCOS:
# - usa get_parent() diretamente;
# - calcula posição em _process, enquanto Player usa física;
# - distância e rotação ainda não são responsabilidade de um WeaponHandler formal.
#
# STATUS:
# PROTOTYPE.

extends Node2D

# Distância radial entre o jogador e o item/arma.
@export var distance := 40

func _process(_delta):
	# Obtém a posição do mouse em coordenadas globais.
	var mouse_pos = get_global_mouse_position()

	# Calcula o vetor que aponta do jogador para o mouse.
	# RISCO: get_parent() é uma dependência estrutural não tipada.
	var direction = mouse_pos - get_parent().global_position

	# Evita normalizar um vetor praticamente zero.
	if direction.length() < 5:
		return

	direction = direction.normalized()

	# Move o item para um ponto fixo ao redor do jogador.
	global_position = get_parent().global_position + direction * distance

	# Gira o item na direção do mouse.
	rotation = direction.angle()
