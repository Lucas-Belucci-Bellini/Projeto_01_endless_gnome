# Combate e World

## Fluxo de combate observado

O fluxo esperado é `Player → HitBox → HurtBox → alvo → dano → reação → morte`, mas a implementação atual possui dois caminhos distintos.

| Origem | Detecção | Chamada de dano | Resultado |
|---|---|---|---|
| Player | `HitBox.get_overlapping_areas()` | `target.take_damage(damage, global_position)` após `area.get_parent()` | Compatível com Player e Enemy. |
| Enemy | Proximidade menor que 45 | `player.take_damage(damage, global_position)` diretamente | Compatível com o Player, mas ignora a HitBox do Enemy. |
| HurtBox | Sinal `area_entered` | `owner.take_damage(hitbox.damage)` | Incompatível com os métodos atuais, que exigem também `attacker_pos`. |

A inconsistência da HurtBox é um problema real de contrato. A menor correção segura é aceitar a origem do dano como propriedade opcional da HitBox e encaminhar dois argumentos, mantendo compatibilidade com a chamada atual do Player. Essa correção deve ser feita somente após o registro deste documento.

## Componentes

`HitBox` é um `Area2D` com `class_name HitBox`, dano exportado e `monitoring = true`. `HurtBox` é um `Area2D` que configura camada 1, máscara 2, monitoring e conexão de `area_entered`. Na cena ativa, Player e Enemy possuem ambos os componentes.

## World

`world.gd` estende `Node2D`, procura `$TileMap` e `$Decoration` e chama `setup_world()` em `_ready()`. O método contém apenas `pass`. Na cena ativa, existe um nó `World` com `TileMapLayer` como filho, mas não foram encontrados nós `TileMap` ou `Decoration` no recorte auditado da cena. Isso indica um contrato de cena possivelmente desatualizado ou incompleto.

Não foi implementada lógica inventada para `setup_world()`. O próximo passo recomendado é decidir, com base na intenção da equipe, se World deve configurar o cenário ou se os campos e o placeholder devem ser removidos em uma alteração isolada.

## Testes

Foram comparadas as assinaturas de `take_damage`, as chamadas de Player/Enemy e a hierarquia da cena ativa. Não foi possível executar o Godot; resultado: `STATIC AUDIT ONLY`.
