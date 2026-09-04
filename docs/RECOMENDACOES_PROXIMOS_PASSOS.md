# Recomendações de Próximos Passos — Endless Gnome

## 1. Resumo executivo

A próxima rodada não deve começar com Spider, boss ou IA avançada. O caminho mais seguro é estabilizar primeiro os contratos já existentes: localizar o Player sem dependência global, definir o ciclo de vida de morte/respawn, centralizar o dano em um fluxo único e esclarecer a responsabilidade de World.

A regra de segurança deve ser: **um contrato por vez, uma alteração pequena por commit e um teste mínimo para cada contrato**. O comportamento atual deve continuar funcionando até que exista uma substituição validada.

## 2. Próximos passos para o Player

### 2.1. Remover gradualmente `Player.instance`

O risco principal é o Enemy depender de uma variável estática que não é limpa quando o Player recebe `queue_free()`. A primeira etapa deve ser criar uma referência explícita ao Player no nível ou em um controlador de combate. O Enemy poderia receber essa referência por propriedade, por método `configure(target)` ou por um grupo bem definido.

A migração recomendada é manter `Player.instance` temporariamente como compatibilidade, adicionar a nova referência explícita e alterar o Enemy para preferi-la. Depois de validar a cena, a variável estática pode ser removida em commit separado.

| Etapa | Mudança | Critério de aceite |
|---|---|---|
| 1 | Definir quem é responsável por fornecer o alvo do Enemy. | A responsabilidade aparece na cena ou no script de World. |
| 2 | Adicionar referência explícita ao alvo. | Enemy funciona sem consultar `Player.instance`. |
| 3 | Manter fallback temporário durante a migração. | Cenas antigas não quebram silenciosamente. |
| 4 | Remover a variável estática. | Nenhum uso restante em scripts ou cenas. |

### 2.2. Definir o ciclo de vida da morte

Player não deve simplesmente desaparecer sem que exista uma decisão explícita. Antes de alterar `queue_free()`, definir um contrato de morte: sinal `died`, estado `alive/dead`, bloqueio de input e, se necessário, um responsável por respawn ou tela de derrota.

Uma sequência conservadora seria emitir `died`, desabilitar colisão e input, executar a reação de morte e somente então deixar o controlador decidir entre respawn, derrota ou troca de cena. O Enemy pode continuar usando `queue_free()` inicialmente, desde que a remoção seja documentada como comportamento temporário e que exista uma política para futuras recompensas ou contagem de inimigos.

### 2.3. Isolar responsabilidades do Player

O Player atualmente movimenta, anima, ataca, recebe dano, aplica knockback e controla invulnerabilidade. Não é necessário separar tudo de uma vez. A primeira extração deve ser apenas um componente de vida/dano ou, alternativamente, um método comum de dano que possa ser testado sem depender da árvore completa da cena.

Antes da extração, registrar os invariantes: vida nunca deve ficar abaixo de zero; dano não deve ser aplicado durante invulnerabilidade; morte deve acontecer uma única vez; knockback precisa de uma origem válida; e o ataque não deve atingir o próprio atacante.

## 3. Próximos passos para o Enemy

### 3.1. Separar alvo, movimento e ataque em contratos pequenos

O Enemy deve continuar com comportamento simples, mas com responsabilidades distinguíveis. Uma ordem adequada é:

1. `TargetProvider` ou referência explícita ao Player.
2. `EnemyMovement`, responsável somente por calcular velocidade e perseguir.
3. `EnemyAttack`, responsável por alcance, cooldown e aplicação de dano.
4. `Health/Damageable`, responsável por vida, invulnerabilidade, knockback e morte.

Não é necessário criar quatro Nodes imediatamente. Os contratos podem começar como métodos privados no próprio script e ser extraídos somente depois de haver testes ou necessidade concreta.

### 3.2. Formalizar estados mínimos

A máquina de estados inicial pode conter apenas `IDLE`, `CHASE`, `ATTACK`, `HURT` e `DEAD`. O objetivo não é criar IA sofisticada, mas evitar que `is_attacking`, `can_attack` e a lógica de movimento produzam combinações inválidas.

| Estado | Pode mover | Pode atacar | Pode receber dano | Transições principais |
|---|---:|---:|---:|---|
| `IDLE` | Não ou pouco | Não | Sim | Player encontrado → `CHASE` |
| `CHASE` | Sim | Não | Sim | Dentro do alcance → `ATTACK` |
| `ATTACK` | Não ou conforme animação | Sim | Sim | Fim do ataque → `CHASE` |
| `HURT` | Knockback | Não | Após invulnerabilidade | Recuperação → estado anterior |
| `DEAD` | Não | Não | Não | Remoção/respawn pelo controlador |

Essa formalização deve vir depois de testes do comportamento atual, para não transformar uma reorganização em mudança de design sem validação.

## 4. Estrutura recomendada para o sistema de combate

### 4.1. Contrato único de dano

A correção da HurtBox resolveu apenas a incompatibilidade de quantidade de argumentos. O próximo passo é substituir argumentos posicionais frágeis por um contrato de dados. Uma opção simples em Godot é um `DamageInfo` como `Resource` ou um objeto leve com campos explícitos:

```gdscript
class_name DamageInfo
extends Resource

@export var amount: int = 0
@export var source: Node2D
@export var origin: Vector2
@export var knockback_force: float = 0.0
```

O alvo poderia expor um único método:

```gdscript
func receive_damage(info: DamageInfo) -> void:
    if is_dead or not can_take_damage:
        return
    health = max(health - info.amount, 0)
    apply_knockback(info.origin, info.knockback_force)
    if health == 0:
        die()
```

O nome exato pode permanecer `take_damage` durante a migração. O importante é que Player, Enemy, HitBox e HurtBox passem a concordar sobre **quantidade, origem, fonte e knockback**.

### 4.2. Unificar os dois fluxos atuais

Hoje o Player usa `HitBox → áreas sobrepostas → target.take_damage`, enquanto o Enemy causa dano diretamente ao Player pela proximidade. A arquitetura recomendada é fazer ambos usarem HitBox/HurtBox. Assim, alcance, camadas de colisão e origem do ataque ficam verificáveis na cena.

A sequência futura deve ser:

`AttackController → HitBox → HurtBox → Damageable → reação → died → World/LevelController`.

O Enemy não deve chamar diretamente um método específico de Player. Ele deve ativar seu ataque e deixar o componente de combate detectar qualquer alvo compatível. Isso evita que cada tipo de inimigo conheça a implementação interna do Player.

### 4.3. Contratos dos componentes

| Componente | Responsabilidade | Não deve decidir |
|---|---|---|
| `HitBox` | Representar uma área ofensiva e produzir `DamageInfo`. | Morte, respawn ou regras globais. |
| `HurtBox` | Detectar HitBoxes e encaminhar o dano ao alvo dono. | Qual animação ou recompensa ocorre. |
| `Damageable`/alvo | Validar invulnerabilidade, reduzir vida, knockback e emitir `died`. | Como o nível faz respawn. |
| `AttackController` | Controlar cooldown e janela ativa do ataque. | Localizar globalmente o Player. |
| `World`/LevelController | Reagir a morte, spawn e troca de fase. | Calcular dano individual. |

### 4.4. Ordem segura de implementação

Primeiro, adicionar testes ou verificações manuais para o contrato atual. Depois, introduzir `DamageInfo` mantendo um adaptador temporário que aceite a assinatura antiga. Em seguida, migrar Player e Enemy individualmente, validar cada cena e somente então remover as chamadas antigas.

Cada etapa deve ser um commit separado: contrato de dano, adaptação da HitBox, migração da HurtBox, migração do Player, migração do Enemy e remoção da compatibilidade antiga.

## 5. Estrutura recomendada para World

### 5.1. Definir responsabilidade antes de corrigir o placeholder

O documento auditado identificou `world.gd` com `setup_world()` vazio e referências a `$TileMap` e `$Decoration`, enquanto a cena apresenta `TileMapLayer`. Isso não deve ser resolvido apenas trocando o nome do node.

A equipe deve primeiro escolher uma destas responsabilidades:

| Opção | Responsabilidade | Quando usar |
|---|---|---|
| `World` como composição visual | Apenas agrupa TileMap, decoração e limites. | Quando a cena já contém tudo manualmente. |
| `World` como controlador do nível | Inicializa entidades, spawn, limites e estado da fase. | Quando o nível precisa de ciclo de vida próprio. |
| `World` como serviço global | Gerencia progressão, troca de cenas e dados persistentes. | Somente se houver necessidade real; evitar global prematuro. |

Para o estado atual, a opção mais segura é começar com `World` como controlador local da fase, sem transformar o node em singleton.

### 5.2. Contrato mínimo sugerido

```gdscript
class_name World
extends Node2D

signal player_died
signal level_ready

@onready var player: Player = $Player
@onready var spawn_point: Marker2D = $SpawnPoint

func _ready() -> void:
    validate_scene_contract()
    configure_player()
    level_ready.emit()

func configure_player() -> void:
    # Fornece dependências explícitas aos inimigos/controladores.
    pass

func handle_player_died() -> void:
    player_died.emit()

func validate_scene_contract() -> void:
    # Verifica nós obrigatórios e falha de forma clara durante desenvolvimento.
    pass
```

O exemplo é um contrato de planejamento, não uma instrução para colar imediatamente. Os nomes reais devem acompanhar a cena existente. Antes disso, deve-se decidir se o node é `TileMap`, `TileMapLayer` ou apenas um agrupador sem script. Se não houver configuração dinâmica, remover `setup_world()` pode ser mais correto do que preenchê-lo com lógica inventada.

## 6. Conteúdo detalhado do `MAPA_DE_CODIGO.md`

O documento gerado na auditoria possui cinco blocos principais.

### 6.1. Escopo da auditoria

Registra que a análise foi estática e informa o estado versionado examinado. Isso é importante porque o documento não afirma que o jogo foi executado; ele delimita a evidência utilizada: scripts, cenas, configuração e estrutura de arquivos.

### 6.2. Linha de implementação ativa

A tabela identifica o projeto Godot ativo, a cena principal, os scripts de Player e Enemy, os componentes de combate e o World. O ponto mais importante é distinguir o que está efetivamente ligado a `level.tscn` do que está apenas armazenado no repositório.

Em particular, ela registra que Player e Enemy são nós diretamente criados em `TestLevel`, que `level.tscn` é a cena principal configurada por UID e que World está parcialmente definido.

### 6.3. Duplicações e protótipos

O mapa lista a árvore de diálogo `teste-grupodejogos-dialogos-at-5/`, a cópia `primeiro_projeto_gnomo/primeiro-projeto-gnomo/`, scripts/cenas de menu duplicados na raiz, o ZIP de 2026 e o arquivo temporário da cena. Também registra que a cópia adicional declara Godot 4.6, enquanto o projeto ativo declara 4.7.

Esse bloco não declara automaticamente que todos esses arquivos devem ser apagados. Ele marca a diferença entre **ativo**, **potencialmente legado** e **não classificado**, preservando a segurança da equipe.

### 6.4. Referências de cena relevantes

O documento enumera os caminhos que os scripts esperam: `Player`, `Enemy`, `Player/HurtBox`, `Player/ItemPosition/WeaponHandler/HitBox`, `Enemy/HurtBox` e `Enemy/HitBox`. Essa seção funciona como checklist para futuras alterações de cena.

### 6.5. Riscos estruturais e limitações

O mapa registra a dependência de `Player.instance`, a ausência de contrato de respawn, a morte via `queue_free()`, o risco de `$TileMap`/`$Decoration` não corresponderem à cena atual e a antiga incompatibilidade da HurtBox, já corrigida no commit `8cfd191`.

Por fim, informa que não havia executável Godot disponível e, por isso, a conclusão da auditoria foi `STATIC AUDIT ONLY`. Essa distinção deve continuar no documento até que alguém execute o projeto no editor ou em CI.

## 7. Sequência sugerida de commits futuros

| Ordem | Commit sugerido | Objetivo |
|---:|---|---|
| 1 | `test: define player death and damage invariants` | Criar testes ou checklist executável para vida, invulnerabilidade e morte. |
| 2 | `refactor: inject enemy target explicitly` | Reduzir dependência de `Player.instance`. |
| 3 | `refactor: centralize damage payload` | Introduzir contrato comum de dano. |
| 4 | `refactor: route enemy attacks through hitbox` | Unificar o fluxo Player/Enemy. |
| 5 | `fix: define player death lifecycle` | Emitir morte e delegar respawn/derrota. |
| 6 | `refactor: define world scene contract` | Resolver a responsabilidade e os nodes esperados por World. |
| 7 | `chore: classify legacy project copies` | Remover ou mover cópias somente após confirmação da equipe. |

## Conclusão

A menor próxima tarefa recomendada é **definir e testar o contrato de morte do Player**, sem ainda remover `Player.instance` nem reescrever o combate. Depois disso, a migração de alvo explícito e a unificação do dano terão uma base observável e reversível.
