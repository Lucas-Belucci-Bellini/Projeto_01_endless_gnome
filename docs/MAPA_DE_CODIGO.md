# Endless Gnome — Mapa de Código

## Objetivo

Este documento registra, arquivo por arquivo, o papel observado no código e o que precisa ser validado antes de qualquer refatoração.

## Implementação top-down / principal candidata

| Arquivo | Papel observado | Estado | Pontos de investigação |
|---|---|---|---|
| `player.gd` | Movimento, ataque, vida, dano, knockback | PROTOTYPE | `Player.instance`, árvore de nós, contrato de dano, morte/respawn |
| `enemy.gd` | Perseguição, ataque, vida, dano, knockback | PROTOTYPE | acoplamento ao Player, IA/combate misturados, morte/recompensa |
| `hit_box.gd` | Área causadora de dano | PROTOTYPE | collision layers, DamageData, origem do golpe |
| `hurt_box.gd` | Área vulnerável | PROTOTYPE / RISCO | assinatura incompatível de `take_damage` |
| `item_position.gd` | Posicionamento/rotação da arma/item | PROTOTYPE | dependência de `get_parent`, sincronização com física |
| `camera_2d.gd` | Câmera e zoom | PROTOTYPE | follow, limites, resolução |
| `world.gd` | Inicialização do mundo | PLACEHOLDER | `setup_world()` vazio e referências de nós |
| `level.tscn` | Integração do protótipo top-down | PROTOTYPE | árvore de nós, colisões, scripts anexados |
| `project.godot` | Configuração do projeto top-down | PROTOTYPE | nome, versão, InputMap e renderer |

## Implementação de plataforma / projeto anterior

Há outra linha contendo `PlayerController`, `Enemy` e `world_test.tscn`, com lógica de plataforma e pulo.

Essa linha não deve receber novas features até ser classificada como oficial, protótipo ou legado.

## Menus na raiz do repositório

| Arquivo | Papel | Estado | Ponto de investigação |
|---|---|---|---|
| `tela_de_titulo.gd` | Tela inicial | PROTOTYPE | integração com projeto oficial |
| `menu_config.gd` | Configurações | PROTOTYPE | áudio ainda não implementado |
| `title_screen.tscn` | Layout de menu | PROTOTYPE | precisa ser associado ao projeto oficial |
| `menu_config.tscn` | Layout de configurações | PROTOTYPE | volume/SFX incompletos |

## Fluxo de dependências observado

```text
Title Screen
   ├── Config Menu
   └── level.tscn
          │
          ├── Player
          │    ├── ItemPosition
          │    │    └── WeaponHandler/HitBox
          │    └── AnimatedSprite2D
          │
          ├── Enemy
          │    └── AnimatedSprite2D
          │
          ├── HurtBox
          └── Camera2D
```

> O diagrama representa a implementação observada no protótipo. Deve ser validado contra a cena real antes de ser usado como arquitetura definitiva.

## Pontos de entrada

### Execução do jogo

O `project.godot` determina a cena principal através de `run/main_scene`.

### Entrada do jogador

`player.gd` lê as ações `up`, `down`, `left`, `right` e `mouse_click`.

### Entrada de ataque do inimigo

`enemy.gd` decide atacar quando a distância até o jogador fica abaixo do limite definido.

## Contratos críticos

```text
Player.take_damage(amount, attacker_pos)
Enemy.take_damage(amount, attacker_pos)
HitBox.damage
HurtBox.area_entered
Player.instance
```

Qualquer mudança em um desses contratos precisa de teste de regressão.

## Código temporário/legado

Arquivos com nomes de teste, versões anteriores, ZIPs ou cópias devem receber classificação explícita antes de serem removidos.

## Regra de manutenção

Não adicionar lógica nova a um arquivo simplesmente porque ele já existe. Primeiro verificar se esse arquivo pertence à implementação oficial e se a responsabilidade dele está definida.
