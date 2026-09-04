# Entidade Player

## Identidade

O Player é um `CharacterBody2D` controlado por `projeto-01-endless-gnome-main/player.gd`. Na cena ativa, ele é criado diretamente como filho de `TestLevel` em `level.tscn`.

## Dependências

O script espera os nós `AnimatedSprite2D` e `ItemPosition/WeaponHandler/HitBox`. A cena ativa também fornece `HurtBox`, `Camera2D`, colisão corporal, arma e os scripts correspondentes. O movimento usa as ações `up`, `down`, `left` e `right`; o ataque usa `mouse_click`.

## Contrato atual

| Membro | Contrato observado |
|---|---|
| `attack()` | Consulta as áreas sobrepostas pela HitBox e chama `take_damage(damage, global_position)` nos alvos encontrados. |
| `take_damage(amount, attacker_pos)` | Reduz vida, inicia invulnerabilidade, aplica knockback, executa flash e remove o Player quando a vida chega a zero. |
| `update_animation(direction)` | Seleciona animações `default`, `walking_up`, `walking_down`, `walking_left` ou `walking_right`. |
| `Player.instance` | Referência estática definida em `_ready()` para permitir que Enemy encontre o Player. |

## Estado observado

O Player começa com `health = max_health`, pode atacar quando `can_attack` é verdadeiro e pode receber dano quando `can_take_damage` é verdadeiro. Durante o ataque, `attacking` fica verdadeiro e o ataque é bloqueado pelo cooldown. Durante o dano, o knockback é aplicado e o dano subsequente é bloqueado pelo tempo de invulnerabilidade.

## Riscos

A referência estática não é limpa quando o Player é liberado. A morte usa `queue_free()` e não há sistema de respawn ou derrota identificado. O ataque depende de `area.get_parent()` para encontrar o alvo, o que torna o contrato dependente da hierarquia exata da cena. A HitBox é tipada genericamente como `Area2D` na referência, embora o script concreto possua `class_name HitBox`.

## Testes

Foi feita inspeção estática dos caminhos de nós, ações de entrada, métodos chamados e cena ativa. Não foi possível executar o Godot no ambiente; resultado: `STATIC AUDIT ONLY`.
