# RESPONSABILIDADE:
# Representar a área vulnerável de uma entidade e encaminhar impactos
# recebidos para o dono dessa área.
#
# CONTRATO ATUAL:
# Recebe áreas que sejam instâncias de HitBox e tenta chamar take_damage
# no `owner` da HurtBox.
#
# BUG/RISCO CRÍTICO: a chamada atual fornece apenas `hitbox.damage`, enquanto
# Player.take_damage e Enemy.take_damage exigem também `attacker_pos`.
# Referência: EG-AUD-003.
#
# STATUS:
# PROTOTYPE — CONTRATO INCOMPATÍVEL A VALIDAR/CORRIGIR.

extends Area2D

func _ready():
	# Define camadas de colisão para que a área detecte a camada esperada.
	# TEST: conferir as máscaras reais usadas pelas HitBoxes nas cenas.
	collision_layer = 1
	collision_mask = 2
	monitoring = true

	# Registra o callback para impactos recebidos.
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox):
	# Só HitBoxes devem gerar dano.
	if hitbox is HitBox:
		# `owner` deve ser a entidade que possui esta HurtBox.
		# RISCO: a semântica de owner depende da árvore da cena.
		if owner != null and owner.has_method("take_damage"):
			# BUG: assinatura incompatível com os `take_damage` atuais.
			# Não alterar nesta etapa de instrumentação; registrar e testar primeiro.
			owner.take_damage(hitbox.damage)
