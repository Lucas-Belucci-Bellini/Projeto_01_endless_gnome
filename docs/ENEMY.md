# Entidade Enemy

## Identidade

O Enemy ativo é um `CharacterBody2D` definido por `projeto-01-endless-gnome-main/enemy.gd` e criado diretamente em `projeto-01-endless-gnome-main/level.tscn`. A cena ativa contém um único nó `Enemy`.

## Dependências

O script espera `AnimatedSprite2D` e usa `Player.instance` para localizar o alvo. O Enemy possui colisão corporal, `HurtBox` e `HitBox` na cena ativa. A perseguição e o ataque dependem da existência de um Player válido.

## Contrato atual

| Membro | Contrato observado |
|---|---|
| `_physics_process(_delta)` | Obtém o Player global, persegue-o quando a distância é maior que 10 e tenta atacar quando a distância é menor que 45. |
| `attack()` | Chama diretamente `player.take_damage(damage, global_position)`, aguarda `attack_pause` e depois `attack_cooldown`. |
| `take_damage(amount, attacker_pos)` | Reduz vida, aplica knockback, executa flash e remove o Enemy quando a vida chega a zero. |
| `flash()` | Modifica temporariamente a modulação de `AnimatedSprite2D`. |

## Estado observado

O Enemy começa com `health = max_health`. `can_attack` controla o ciclo de ataque; `is_attacking` representa a pausa do ataque; `can_take_damage` controla a invulnerabilidade. Quando não está atacando, move-se em direção ao Player. A IA, o movimento, o dano e a morte estão concentrados no mesmo script.

## Comportamento atual versus planejado

O comportamento atual é perseguição simples baseada em distância, ataque direto ao método do Player e morte por `queue_free()`. Não foi implementada IA avançada, máquina de estados formal, spawn, respawn ou separação de responsabilidades. Esses itens permanecem como planejamento e não foram adicionados nesta rodada.

## Riscos

O Enemy depende de `Player.instance`, não possui tratamento explícito para a destruição do Player e soma knockback à velocidade em mais de um ponto do fluxo de física. A morte não possui sinal ou contrato de respawn identificado. O ataque direto do Enemy não passa pela própria HitBox, criando um fluxo diferente do ataque do Player.

## Testes

Foi feita inspeção estática do script, da cena ativa e das chamadas entre Enemy e Player. Não foi possível executar o Godot no ambiente; resultado: `STATIC AUDIT ONLY`.
