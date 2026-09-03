# Endless Gnome — Especificação de Entidades

> Modelo padrão para documentar qualquer personagem, inimigo, objeto interativo ou entidade relevante antes de ampliar seu comportamento.

## 1. Identificação

**Nome:**

**ID interno:**

**Categoria:** Player / Enemy / NPC / Boss / Object / Collectible / Other

**Status:** PLANEJADO / PROTOTYPE / OFFICIAL / LEGACY / EXPERIMENTAL

**Cena:**

**Script principal:**

## 2. Propósito

Descrever em linguagem simples qual função a entidade possui no jogo.

Exemplo:

> A aranha é um inimigo terrestre de curto alcance destinado a pressionar o jogador em corredores estreitos.

## 3. Núcleo mínimo

Antes de adicionar comportamento complexo, a entidade deve possuir:

- cena carregável;
- script sem erro;
- sprite/modelo;
- collider;
- posição/spawn válido;
- estado inicial definido;
- componentes obrigatórios;
- capacidade de ser destruída/removida de forma controlada.

## 4. Árvore de nós

Registrar a estrutura esperada.

```text
Spider
├── Visual
├── CollisionShape2D
├── Health
├── HurtBox
├── HitBox
├── DetectionArea
└── AnimationPlayer
```

A árvore documentada deve corresponder à árvore real da cena aprovada.

## 5. Componentes

Para cada componente, registrar:

| Componente | Obrigatório | Responsabilidade | Dependências |
|---|---|---|---|
| Visual | Sim | apresentação | sprite/animation |
| Collider | Sim | colisão física | physics layers |
| Health | Conforme entidade | vida | damage contract |
| HurtBox | Conforme entidade | receber dano | HitBox |
| HitBox | Conforme entidade | causar impacto | damage contract |

## 6. Atributos

Exemplo:

```text
max_health
move_speed
detection_range
attack_range
attack_damage
attack_cooldown
knockback_resistance
reward
```

Cada atributo deve possuir unidade/escala clara quando necessário.

## 7. Estados

Listar todos os estados possíveis.

Exemplo:

```text
Idle
Patrol
Detect
Chase
Attack
Hurt
Dead
```

Para cada transição importante:

```text
Idle → Patrol quando a entidade inicia patrulha.
Patrol → Detect quando o Player entra no alcance.
Detect → Chase quando o alvo é confirmado.
Chase → Attack quando entra no alcance de ataque.
Attack → Chase após o ataque.
Qualquer estado → Hurt quando recebe dano válido.
Qualquer estado → Dead quando a vida chega a zero.
```

## 8. Entradas

Registrar tudo que pode provocar mudança de comportamento.

```text
Input direto
Sinal
Timer
Detecção
Colisão
Dano
Objetivo
Evento global
```

## 9. Saídas e eventos

Registrar os eventos emitidos pela entidade.

Exemplo:

```text
health_changed
attack_started
attack_hit
damaged
died
reward_dropped
```

## 10. Dependências

Listar:

- nós da própria cena;
- cenas instanciadas;
- autoloads;
- managers;
- recursos externos;
- outros objetos;
- grupos;
- collision layers/masks;
- InputMap;
- sinais.

## 11. Contratos públicos

Documentar métodos acessados externamente.

Exemplo:

```text
func take_damage(amount, source)
func interact(actor)
func get_state()
```

Definir entrada, saída e condições de erro.

## 12. Regras de dano

Quando aplicável:

```text
Quem pode causar dano?
Quem pode receber?
Qual o valor padrão?
Existe invulnerabilidade?
Existe knockback?
Como a fonte é identificada?
O dano pode ocorrer apenas uma vez por ataque?
```

## 13. Regras de movimento

Documentar:

- velocidade;
- aceleração;
- desaceleração;
- gravidade;
- salto;
- limites;
- colisão;
- interação com knockback;
- interação com estados.

## 14. Regras de animação

Na fase funcional, registrar somente o necessário para sincronização.

Exemplo:

```text
Attack
→ antecipação
→ janela ativa
→ impacto
→ recuperação
```

O polimento visual detalhado deve permanecer na documentação de animação/game feel.

## 15. Regras de morte

Definir explicitamente:

```text
Quando morre?
Qual estado final?
Pode emitir evento?
Dropa recompensa?
Desaparece imediatamente?
Toca animação?
Pode reaparecer?
```

Não usar `queue_free()` como definição arquitetural de morte. A remoção da cena é uma consequência possível de um estado de morte.

## 16. Testes mínimos

Uma entidade nova deve possuir pelo menos:

### Smoke

- cena abre;
- script carrega;
- entidade aparece;
- collider funciona.

### Funcional

- estado inicial funciona;
- entrada principal funciona;
- interação principal funciona;
- dano/morte funcionam quando aplicáveis.

### Integração

- funciona dentro de uma fase;
- não quebra Player;
- não quebra HUD;
- não quebra progressão;
- não gera referências inválidas.

## 17. Casos de borda

Verificar:

- alvo inexistente;
- alvo removido durante a ação;
- dano simultâneo;
- vida zero;
- valor negativo;
- distância zero;
- colisão duplicada;
- cena trocada durante ação;
- entidade criada e destruída rapidamente.

## 18. Pendências

```text
TODO:
FIXME:
RISK:
DEPRECATED:
```

Cada pendência importante deve receber referência no registro de problemas.

## 19. Histórico

Registrar alterações estruturais:

```text
Data / Commit / Mudança / Motivo
```

## 20. Critério para evolução

Uma entidade pode receber comportamento novo quando:

- seu núcleo funciona;
- suas dependências estão documentadas;
- seu estado inicial é conhecido;
- seu contrato está definido;
- o teste mínimo passa.

## 21. Exemplo de evolução segura

```text
Spider v0
└── nasce corretamente

Spider v1
└── possui estado Idle

Spider v2
└── patrulha

Spider v3
└── detecta Player

Spider v4
└── persegue

Spider v5
└── ataca

Spider v6
└── recebe dano e morre

Spider v7
└── recebe animação/game feel
```

Cada versão deve manter os contratos anteriores, salvo mudança deliberada e documentada.

## Regra final

**Não começar pela mecânica mais visível. Começar pelo núcleo que torna a entidade confiável.**
