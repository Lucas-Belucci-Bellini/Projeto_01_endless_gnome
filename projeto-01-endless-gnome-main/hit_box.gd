# RESPONSABILIDADE:
# Representar uma área que pode causar dano.
#
# CONTRATO:
# A cena proprietária fornece a área de colisão. O valor `damage` deve ser
# consumido pelo sistema de dano ao detectar uma HurtBox válida.
#
# RISCOS CONHECIDOS:
# - o dano está acoplado diretamente ao nó;
# - não existe informação de origem, equipe/fação ou tipo de dano;
# - regras de collision layer/mask estão distribuídas entre cenas e scripts.
#
# STATUS:
# PROTOTYPE.

class_name HitBox
extends Area2D

# Quantidade de dano associada a esta HitBox.
# TODO: substituir por DamageData quando o contrato de combate for consolidado.
@export var damage := 1

func _ready():
	# Ativa a detecção de áreas/corpos conforme a configuração da cena.
	# TEST: validar collision_layer/collision_mask na cena que usa esta classe.
	monitoring = true
