# Mapa de Código — Endless Gnome

## Escopo da auditoria

Esta rodada analisou o estado versionado do repositório `Projeto_01_endless_gnome` em 4 de setembro de 2026. A análise foi estática, baseada nos scripts, cenas, configuração e estrutura de arquivos presentes no commit inicial da rodada.

## Linha de implementação ativa

| Elemento | Localização | Estado observado |
|---|---|---|
| Projeto Godot ativo | `projeto-01-endless-gnome-main/project.godot` | Projeto principal identificado. |
| Cena principal | `projeto-01-endless-gnome-main/level.tscn` | Configurada por UID em `project.godot`. |
| Player ativo | `projeto-01-endless-gnome-main/level.tscn` + `player.gd` | Instanciado diretamente na cena `TestLevel`. |
| Enemy ativo | `projeto-01-endless-gnome-main/level.tscn` + `enemy.gd` | Um inimigo instanciado diretamente na cena `TestLevel`. |
| Combate | `hit_box.gd`, `hurt_box.gd` e métodos de Player/Enemy | Há dois fluxos: ataque direto do Enemy e detecção por áreas do Player/HurtBox. |
| World | Node `World` dentro de `level.tscn` + `world.gd` | Estrutura parcialmente definida; `setup_world()` é placeholder. |

## Duplicações e protótipos

Há uma segunda árvore de projeto em `teste-grupodejogos-dialogos-at-5/`, com `entities/player.gd`, `entities/player.tscn`, NPC e diálogo. Ela possui seu próprio `project.godot` e não é referenciada pela cena principal do projeto ativo. Também foi confirmada uma cópia adicional em `primeiro_projeto_gnomo/primeiro-projeto-gnomo/`, com os mesmos scripts de gameplay e `level.tscn`; sua configuração declara Godot 4.6, enquanto o projeto ativo declara 4.7. Essa cópia foi tratada como potencialmente legada e não foi alterada nesta rodada.

Também existe um diretório `projeto-01-endless-gnome-main/` contendo o projeto Godot principal, enquanto o diretório raiz do repositório contém scripts e cenas de menu duplicados, um ZIP (`2026_gnomo-game-code.zip`) e o arquivo temporário `level.tscn700895048.tmp` dentro do projeto principal. A auditoria não removeu esses itens porque ainda não há evidência suficiente de que sejam obsoletos ou não utilizados por colaboradores.

## Referências de cena relevantes

A cena `level.tscn` declara os nós `Player`, `Enemy`, `Player/HurtBox`, `Player/ItemPosition/WeaponHandler/HitBox`, `Enemy/HurtBox` e `Enemy/HitBox`. Esses caminhos correspondem às referências principais encontradas em `player.gd`, `enemy.gd` e nos scripts de combate.

## Riscos estruturais

O projeto depende de `Player.instance` como referência global para o Enemy. O Player e o Enemy removem a si próprios com `queue_free()` ao morrer, mas não existe nesta rodada um contrato de respawn, tela de derrota ou limpeza explícita da referência estática. O `World` possui referências `@onready` a `$TileMap` e `$Decoration`, embora a cena auditada apresente `TileMapLayer` sob `World`; esse risco foi documentado, não inventado nem corrigido sem teste de execução.

O contrato de `HurtBox` estava inconsistente com os métodos `take_damage` de Player e Enemy: o componente chamava o método com um argumento, enquanto as implementações exigiam `amount` e `attacker_pos`. Essa correção foi isolada em commit próprio após o registro da auditoria.

## Limitações

Não foi localizado um executável `godot` ou `godot4` no ambiente de auditoria. Portanto, a validação de cena e execução do jogo deve ser classificada como `STATIC AUDIT ONLY` até que o projeto seja aberto no Godot Editor ou em um ambiente com o engine instalado.

## Referências

Não foram utilizadas fontes externas. Todas as afirmações deste documento derivam dos arquivos versionados no próprio repositório.
