# Registro de Problemas — Rodada de Fundação

## Rodada

Auditoria incremental do projeto Endless Gnome, iniciada em 4 de setembro de 2026, na branch `docs/auditoria-fundacao`.

## Descoberto

A cena principal está em `projeto-01-endless-gnome-main/level.tscn` e usa diretamente `player.gd` e `enemy.gd`. Existe uma segunda linha de protótipo em `teste-grupodejogos-dialogos-at-5/`, além de scripts e cenas de menu duplicados na raiz. O repositório também contém um ZIP e um arquivo temporário versionado.

O Player e o Enemy funcionam como `CharacterBody2D`, concentram movimentação e combate em seus scripts e dependem de caminhos de nós específicos. O Enemy encontra o Player pela variável estática `Player.instance`. O Player consulta áreas sobrepostas para atacar; o Enemy ataca diretamente o método do Player.

Foi confirmada uma incompatibilidade entre `HurtBox._on_area_entered()` e as assinaturas de `take_damage(amount, attacker_pos)` de Player e Enemy. A HurtBox passa somente o dano e, portanto, pode gerar erro em tempo de execução quando esse caminho for acionado.

`world.gd` chama `setup_world()` sem implementação e procura nós `$TileMap` e `$Decoration`, enquanto a cena ativa apresenta `TileMapLayer` sob `World`. O escopo e a responsabilidade de World ainda não estão definidos.

## Corrigido

Nesta etapa de documentação, nenhuma regra de gameplay foi alterada. A correção mínima do contrato HurtBox foi identificada e será isolada em commit próprio, após esta documentação.

## Documentado

Foram criados `docs/MAPA_DE_CODIGO.md`, `docs/PLAYER.md`, `docs/ENEMY.md` e `docs/COMBATE_E_WORLD.md`. Este documento registra os problemas e decisões da rodada.

## Testado

Foi realizada auditoria estática dos arquivos, referências `res://`, hierarquia da cena principal, chamadas de métodos, sinais e presença de placeholders. Também foi verificado o estado inicial do Git e a existência de arquivos temporários e duplicados.

## Não testado

Não foi possível abrir ou executar o projeto no Godot porque não foi encontrado um executável `godot` ou `godot4` no ambiente. Não foi executado teste de gameplay, validação de cena em runtime, build ou teste automatizado. O resultado correto para esta limitação é `STATIC AUDIT ONLY`.

## Riscos restantes

Permanecem sem correção nesta rodada, até haver evidência adicional: dependência global de `Player.instance`, ausência de respawn após `queue_free()`, ataque dependente de `get_parent()`, concentração de responsabilidades em Enemy, `ItemPosition` usando `_process`, menus parcialmente implementados, duplicações/protótipos e o contrato indefinido de World.

## Próximo passo

Corrigir apenas a passagem da origem do dano pela HurtBox, usando a posição global da HitBox como origem, sem refatorar Player ou Enemy. Depois validar estaticamente todas as chamadas e publicar o commit correspondente.

## Commits

A lista será preenchida após cada commit e publicação no GitHub.
