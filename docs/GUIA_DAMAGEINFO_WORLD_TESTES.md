# Guia Prático — DamageInfo, HitBoxes, World e Testes

> Este material é um exemplo de arquitetura para a próxima refatoração. Ele não deve ser aplicado inteiro em um único commit. A migração deve preservar o comportamento atual e avançar por contratos pequenos, compiláveis e testáveis.

## 1. Objetivo da refatoração

O objetivo é fazer Player e Enemy usarem o mesmo fluxo de combate:

```text
AttackController → HitBox → HurtBox → Damageable → died → World
```

A HitBox não deve conhecer Player ou Enemy. A HurtBox não deve calcular regras de morte. O alvo deve receber um pacote de dano comum. O World deve reagir aos eventos do nível, mas não deve ser um singleton que todos os objetos consultam.

## 2. Contrato `DamageInfo`

Crie um arquivo `damage_info.gd` no diretório comum das entidades:

```gdscript
class_name DamageInfo
extends Resource

## Quantidade de vida removida do alvo.
@export var amount: int = 0

## Objeto que causou o dano. Pode ser Player, Enemy ou outro atacante.
var source: Node = null

## Posição usada para calcular knockback.
var origin: Vector2 = Vector2.ZERO

## Força específica deste ataque. Zero significa usar o padrão do alvo.
@export var knockback_force: float = 0.0

## Identificador opcional para logs, efeitos ou telemetria local.
@export var attack_id: StringName = &"unknown"

static func create(
        damage_amount: int,
        damage_source: Node,
        damage_origin: Vector2,
        force: float = 0.0,
        id: StringName = &"unknown"
) -> DamageInfo:
    var info := DamageInfo.new()
    info.amount = maxi(damage_amount, 0)
    info.source = damage_source
    info.origin = damage_origin
    info.knockback_force = maxf(force, 0.0)
    info.attack_id = id
    return info
```

O uso de campos nomeados evita que chamadas como `take_damage(1, position)` percam significado quando o contrato crescer. `source` deve ser tratado como opcional: ataques ambientais podem não ter um Node atacante.

## 3. Alvo que recebe dano

Para a primeira migração, o comportamento pode permanecer no próprio Player e Enemy. O método comum deve ser `receive_damage(info: DamageInfo)`:

```gdscript
signal damaged(info: DamageInfo, remaining_health: int)
signal died

@export var max_health: int = 5
@export var default_knockback_force: float = 700.0

var health: int
var is_dead := false
var can_take_damage := true

func _ready() -> void:
    health = max_health

func receive_damage(info: DamageInfo) -> void:
    if is_dead or not can_take_damage:
        return
    if info == null or info.amount <= 0:
        return

    can_take_damage = false
    health = maxi(health - info.amount, 0)

    var force := info.knockback_force
    if is_zero_approx(force):
        force = default_knockback_force
    apply_knockback(info.origin, force)
    damaged.emit(info, health)

    if health == 0:
        die()
        return

    await get_tree().create_timer(invulnerability_time).timeout
    if not is_dead:
        can_take_damage = true

func apply_knockback(origin: Vector2, force: float) -> void:
    var direction := global_position - origin
    if direction.is_zero_approx():
        return
    knockback_velocity = direction.normalized() * force

func die() -> void:
    if is_dead:
        return
    is_dead = true
    can_take_damage = false
    set_physics_process(false)
    died.emit()
```

Na implementação real, `invulnerability_time`, `knockback_velocity` e a animação devem permanecer nos scripts que já os possuem ou ser extraídos para um componente comum. O exemplo acima define o contrato; não exige uma reescrita imediata.

Durante a migração, um adaptador temporário pode preservar chamadas antigas:

```gdscript
func take_damage(amount: int, attacker_pos: Vector2) -> void:
    var info := DamageInfo.create(
        amount,
        null,
        attacker_pos,
        knockback_force,
        &"legacy_call"
    )
    receive_damage(info)
```

Quando todas as chamadas forem migradas para `receive_damage`, o adaptador antigo pode ser removido em commit separado.

## 4. HitBox unificada

Substitua o script específico por uma HitBox neutra:

```gdscript
class_name HitBox
extends Area2D

@export var damage: int = 1
@export var knockback_force: float = 0.0
@export var attack_id: StringName = &"basic_attack"

## Definido pelo controlador ou pelo dono da HitBox.
var source: Node = null
var active := false

func _ready() -> void:
    monitoring = true
    active = false

func activate() -> void:
    active = true
    monitoring = true

func deactivate() -> void:
    active = false

func build_damage_info() -> DamageInfo:
    return DamageInfo.create(
        damage,
        source,
        global_position,
        knockback_force,
        attack_id
    )
```

Existem duas opções válidas para ativação. Na opção conservadora, a HitBox permanece monitorando e o código de ataque consulta as áreas sobrepostas. Na opção mais previsível, `activate()` e `deactivate()` delimitam a janela de acerto da animação. A segunda opção deve ser adotada somente quando a cena possuir animações ou sinais confiáveis.

## 5. HurtBox unificada

A HurtBox apenas traduz uma colisão em uma entrega de dano:

```gdscript
class_name HurtBox
extends Area2D

@export var damage_target_path: NodePath = NodePath("..")

var damage_target: Node = null
var already_hit: Dictionary[int, bool] = {}

func _ready() -> void:
    collision_layer = 1
    collision_mask = 2
    monitoring = true
    damage_target = get_node_or_null(damage_target_path)
    area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    if not area is HitBox:
        return
    var hitbox := area as HitBox
    if not hitbox.active:
        return
    if damage_target == null or not damage_target.has_method("receive_damage"):
        push_warning("HurtBox sem alvo Damageable: %s" % get_path())
        return
    if hitbox.source == damage_target:
        return

    var hit_key := hitbox.get_instance_id()
    if already_hit.has(hit_key):
        return
    already_hit[hit_key] = true
    damage_target.receive_damage(hitbox.build_damage_info())
```

O dicionário `already_hit` precisa ser limpo por ataque, não necessariamente por frame. Uma alternativa é o AttackController carregar um `attack_token` único em cada ativação. Para ataques contínuos, como uma área de veneno, a política deve ser explicitamente diferente e baseada em cooldown.

Na cena, a HitBox do Player e a HitBox do Enemy devem usar o mesmo script. O Enemy não deve chamar `player.take_damage(...)` diretamente. Ele deve ativar sua HitBox, de modo que Player e Enemy atravessem o mesmo contrato.

## 6. AttackController mínimo

Um controlador simples pode ser um Node filho do atacante:

```gdscript
class_name AttackController
extends Node

@export var hitbox_path: NodePath
@export var cooldown := 0.3

var hitbox: HitBox
var source: Node
var can_attack := true

func _ready() -> void:
    source = get_parent()
    hitbox = get_node(hitbox_path) as HitBox
    hitbox.source = source

func try_attack() -> bool:
    if not can_attack:
        return false
    can_attack = false
    hitbox.activate()
    await get_tree().physics_frame
    hitbox.deactivate()
    await get_tree().create_timer(cooldown).timeout
    can_attack = true
    return true
```

O Player pode chamar `attack_controller.try_attack()`. O Enemy pode fazer a mesma chamada quando o alvo estiver dentro do alcance. A decisão de atacar continua no Player/Enemy, mas a entrega do dano não depende mais do tipo concreto do alvo.

## 7. Diretrizes para desacoplar World

### 7.1. World deve ser dono da composição, não um serviço global

World deve conhecer os objetos que compõem a fase: Player, spawn points, inimigos e limites. Player e Enemy não devem procurar World por `get_tree().root`, `get_node("/root/World")` ou singleton. Se uma entidade precisa comunicar algo, deve emitir um sinal ou receber uma dependência explícita.

### 7.2. Injete dependências na inicialização

O World pode configurar o alvo dos inimigos sem que eles procurem `Player.instance`:

```gdscript
extends Node2D

@onready var player: Player = $Player
@onready var enemies_root: Node = $Enemies

func _ready() -> void:
    for enemy in enemies_root.get_children():
        if enemy.has_method("set_target"):
            enemy.set_target(player)
    player.died.connect(_on_player_died)

func _on_player_died() -> void:
    # O World decide entre respawn, derrota ou troca de cena.
    pass
```

O Enemy expõe apenas:

```gdscript
var target: Node2D

func set_target(new_target: Node2D) -> void:
    target = new_target
```

O fallback temporário para `Player.instance` pode existir durante a migração, mas deve emitir aviso e ter prazo de remoção.

### 7.3. World deve reagir a sinais, não controlar detalhes de combate

World pode escutar `player.died`, `enemy.died` ou `player.respawn_requested`. Ele não deve reduzir vida, decidir knockback ou inspecionar a HitBox. Essas decisões pertencem aos componentes de combate e vida.

### 7.4. Defina uma interface de respawn

Uma interface local e explícita pode ser:

```gdscript
func respawn_player() -> void:
    var spawn := $SpawnPoints/PlayerSpawn
    player.revive_at(spawn.global_position)
```

O método `revive_at()` deve ser responsabilidade do Player ou de um componente de vida. World apenas escolhe **quando** e **onde** o respawn ocorre.

### 7.5. Corrija o contrato de nós antes da lógica

O `world.gd` auditado procura `$TileMap` e `$Decoration`, mas a cena apresenta `TileMapLayer`. Antes de implementar `setup_world()`, escolha uma responsabilidade: agrupador visual, controlador local de fase ou outro papel documentado. Depois altere os caminhos e a cena no mesmo commit, com validação de nós obrigatórios.

## 8. Testes unitários do ciclo de dano e morte

O teste unitário deve testar a regra sem depender de física, sprites ou da cena completa. Em um projeto sem framework, pode ser um Node de teste executado por uma cena dedicada; em uma equipe maior, GUT ou outro framework pode fornecer melhor organização.

Exemplo conceitual de teste sem framework externo:

```gdscript
extends Node

func _ready() -> void:
    test_damage_reduces_health()
    test_invulnerability_blocks_repeated_damage()
    test_zero_health_emits_died_once()
    test_damage_from_same_source_is_not_special_without_policy()
    print("Player damage tests passed")
    get_tree().quit()

func make_player() -> Player:
    var player := preload("res://player.tscn").instantiate() as Player
    add_child(player)
    await get_tree().process_frame
    return player

func test_damage_reduces_health() -> void:
    var player := await make_player()
    var info := DamageInfo.create(2, null, Vector2(-10, 0))
    player.receive_damage(info)
    assert(player.health == player.max_health - 2)
    player.queue_free()

func test_invulnerability_blocks_repeated_damage() -> void:
    var player := await make_player()
    var info := DamageInfo.create(1, null, Vector2(-10, 0))
    player.receive_damage(info)
    var health_after_first_hit := player.health
    player.receive_damage(info)
    assert(player.health == health_after_first_hit)
    player.queue_free()

func test_zero_health_emits_died_once() -> void:
    var player := await make_player()
    var deaths := 0
    player.died.connect(func(): deaths += 1)
    var info := DamageInfo.create(player.max_health, null, Vector2.ZERO)
    player.receive_damage(info)
    assert(player.is_dead)
    assert(deaths == 1)
    player.queue_free()
```

O código é ilustrativo: se `receive_damage()` contiver `await`, o teste deve aguardar `process_frame` ou um sinal antes de verificar estados assíncronos. O teste não deve depender de tempo real arbitrário quando puder aguardar sinais.

## 9. Testes de integração para respawn

O teste de integração deve instanciar a cena do World e verificar comunicação entre World, Player e spawn point. O fluxo mínimo é:

1. Instanciar World.
2. Confirmar que Player e SpawnPoint existem.
3. Conectar um contador ao sinal `player.died`.
4. Aplicar dano letal ao Player.
5. Aguardar o sinal de morte.
6. Chamar ou aguardar a política de respawn do World.
7. Verificar que o Player está vivo, com vida máxima e na posição do SpawnPoint.
8. Verificar que o sinal de morte foi emitido uma vez, não em loop.

Exemplo de estrutura:

```gdscript
extends Node

func test_world_respawns_player() -> void:
    var world := preload("res://level.tscn").instantiate()
    add_child(world)
    await get_tree().process_frame

    var player: Player = world.get_node("Player")
    var spawn: Marker2D = world.get_node("SpawnPoints/PlayerSpawn")
    var deaths := 0
    player.died.connect(func(): deaths += 1)

    player.receive_damage(
        DamageInfo.create(player.max_health, null, player.global_position)
    )
    await get_tree().process_frame

    assert(deaths == 1)
    assert(world.has_method("respawn_player"))
    world.respawn_player()
    await get_tree().process_frame

    assert(not player.is_dead)
    assert(player.health == player.max_health)
    assert(player.global_position.is_equal_approx(spawn.global_position))
    world.queue_free()
```

Se o design escolher recriar a instância em vez de reviver a mesma, o teste deve guardar a referência antes da morte, localizar a nova instância depois do respawn e verificar que a antiga foi liberada. Essa decisão precisa ser documentada; não se deve testar simultaneamente os dois comportamentos.

## 10. Matriz mínima de testes

| ID | Tipo | Cenário | Resultado esperado |
|---|---|---|---|
| P-01 | Unitário | Dano positivo | Vida reduzida exatamente pelo valor válido. |
| P-02 | Unitário | Dano zero ou negativo | Nenhuma alteração de vida. |
| P-03 | Unitário | Segundo dano durante invulnerabilidade | Segundo dano ignorado. |
| P-04 | Unitário | Dano letal | `is_dead = true` e `died` emitido uma vez. |
| P-05 | Unitário | Dano depois da morte | Nenhuma nova redução ou emissão. |
| C-01 | Integração | Player HitBox toca Enemy HurtBox | Enemy recebe `DamageInfo` com origem correta. |
| C-02 | Integração | Enemy HitBox toca Player HurtBox | Player recebe o mesmo contrato de dano. |
| C-03 | Integração | Fonte é o próprio alvo | Dano próprio bloqueado, se essa for a regra. |
| W-01 | Integração | World configura Enemy | Enemy recebe alvo explícito sem `Player.instance`. |
| W-02 | Integração | Player morre | World recebe sinal de morte uma vez. |
| W-03 | Integração | Respawn | Player reaparece ou é recriado conforme contrato definido. |
| W-04 | Integração | World sem nó obrigatório | Erro claro ou falha de validação, não null silencioso. |

## 11. Ordem recomendada de implementação

A sequência mais segura é:

1. Adicionar `DamageInfo` sem migrar chamadas.
2. Adicionar `receive_damage()` como adaptador ao método existente.
3. Migrar HurtBox e testar Player/Enemy.
4. Tornar a HitBox do Enemy ativa e unificar o ataque.
5. Criar `died` e definir se o Player será revivido ou recriado.
6. Fazer World conectar sinais e injetar alvos.
7. Remover `Player.instance` somente quando não houver usos.
8. Validar as cenas e executar a matriz completa.

Cada item deve ser um commit lógico. O projeto auditado não deve receber uma grande refatoração antes de haver um ambiente Godot disponível para executar as cenas.

## 12. Critérios de conclusão

A refatoração pode ser considerada pronta quando Player e Enemy utilizarem o mesmo formato de dano, nenhum ataque conhecer diretamente o tipo concreto do alvo, World não for consultado como singleton, a política de morte/respawn estiver documentada, os nós obrigatórios forem validados e os testes unitários e de integração passarem em ambiente com Godot.
