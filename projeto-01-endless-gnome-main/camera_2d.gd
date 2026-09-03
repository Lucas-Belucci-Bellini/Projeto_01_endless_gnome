# RESPONSABILIDADE:
# Configurar a Camera2D do protótipo e aplicar seu zoom inicial.
#
# RISCOS:
# - a câmera depende da cena para receber os limites/follow corretos;
# - zoom fixo pode não servir para todas as resoluções;
# - não há transição ou regra documentada de câmera ainda.
#
# STATUS:
# PROTOTYPE.

extends Camera2D

# Fator de zoom configurável pelo editor.
# TEST: validar a leitura visual em diferentes resoluções e escalas.
@export var zoom_value := 2.0

func _ready():
	# Torna esta câmera a câmera ativa da cena.
	make_current()

	# Aplica o mesmo fator de zoom nos eixos X/Y.
	zoom = Vector2(zoom_value, zoom_value)
