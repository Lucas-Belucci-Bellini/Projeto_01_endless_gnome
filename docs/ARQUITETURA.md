# Endless Gnome — Arquitetura Técnica

## Objetivo

Definir responsabilidades, dependências e limites dos sistemas para impedir que o projeto cresça em scripts monolíticos e referências circulares.

## Estrutura alvo

```text
res://
├── project.godot
├── scenes/
│   ├── main/
│   ├── levels/
│   ├── player/
│   ├── enemies/
│   ├── objects/
│   └── ui/
├── scripts/
│   ├── core/
│   ├── player/
│   ├── combat/
│   ├── enemies/
│   ├── world/
│   ├── progression/
│   ├── narrative/
│   └── ui/
├── assets/
│   ├── sprites/
│   ├── tilesets/
│   ├── audio/
│   ├── fonts/
│   └── ui/
├── data/
│   ├── items/
│   ├── enemies/
│   ├── dialogue/
│   └── levels/
└── docs/
```

## Camadas

### Core

Responsável por serviços globais e ciclo de vida.

Exemplos:

- GameManager
- SceneManager
- SaveManager
- AudioManager
- Input/configuração

### Gameplay

Responsável pelo comportamento em tempo de jogo.

Exemplos:

- Player
- Enemy
- Combat
- Health
- Damage
- Interaction

### World

Responsável por elementos da fase.

Exemplos:

- Level
- Door
- Checkpoint
- MineCart
- Crystal
- Puzzle

### Progression

Responsável pelo estado persistente e progressão.

Exemplos:

- Currency
- Inventory
- Unlocks
- Objectives
- LevelProgress

### Narrative

Responsável por conteúdo narrativo.

Exemplos:

- Dialogue
- Artefact
- Lore
- Character data

### UI

Responsável apenas por apresentação e entrada de interface.

## Regras de dependência

1. UI pode observar sistemas de gameplay, mas não deve implementar regras de dano ou progressão.
2. Player não deve conhecer detalhes de telas de menu.
3. Enemy não deve controlar HUD.
4. Level coordena entidades e condições do nível, mas não deve conter todos os comportamentos de entidades.
5. SaveManager persiste estado; não deve executar gameplay.
6. Dados de itens/inimigos/diálogos devem ser separados da lógica sempre que o conteúdo ficar grande.
7. Sistemas globais devem ser usados somente quando realmente compartilhados.

## Componentes recomendados

### HealthComponent

Responsabilidades:

- vida máxima;
- vida atual;
- receber dano;
- emitir sinais de mudança;
- detectar morte.

Não deve:

- desenhar barra de vida;
- decidir texto da UI;
- controlar animação específica de uma entidade.

### DamageData

Contrato mínimo:

```text
amount
source
knockback
hit_position
hit_direction
flags
```

O contrato deve ser pequeno e extensível.

### HitBox / HurtBox

- HurtBox representa área vulnerável.
- HitBox representa área que pode causar impacto.
- Dano é processado por um sistema/contrato explícito.
- Não usar `queue_free()` como substituto de morte.

## Estados

Entidades com comportamento complexo devem usar máquina de estados ou estados equivalentes.

Player:

```text
Idle
Run
Jump
Fall
Attack
Hurt
Dead
```

Enemy:

```text
Idle
Patrol
Chase
Attack
Hurt
Dead
```

## Comunicação

Preferir sinais/eventos para desacoplar sistemas quando apropriado.

Exemplo:

```text
Enemy morreu
   ↓
Enemy emite died/reward
   ↓
Progression coleta recompensa
   ↓
HUD recebe atualização
```

Evitar cadeias de chamadas como:

```text
Enemy → HUD → Player → Shop → Level
```

## Dados e conteúdo

Quando quantidade de conteúdo crescer, separar dados da implementação.

Exemplo conceitual:

```text
EnemyDefinition
  id
  max_health
  move_speed
  damage
  reward
```

O mesmo princípio vale para itens, armas, diálogos e objetivos.

## Cenas

Cenas devem ter uma responsabilidade clara e possuir nomes previsíveis.

Evitar nomes de protótipo como `world_test.tscn` na versão final da Demo.

## Critério arquitetural

Antes de adicionar um novo sistema, responder:

- Qual problema ele resolve?
- Qual objeto é dono do estado?
- Quem pode chamar esse sistema?
- Qual entrada ele recebe?
- Qual saída/evento ele produz?
- Como será testado?
- Ele precisa ser global ou pode ser local à cena?

## Regra contra código monolítico

Um script deve ser dividido quando estiver acumulando responsabilidades independentes, por exemplo:

```text
movimento + combate + vida + inventário + diálogo + UI
```

Isso é um forte sinal de separação necessária.
