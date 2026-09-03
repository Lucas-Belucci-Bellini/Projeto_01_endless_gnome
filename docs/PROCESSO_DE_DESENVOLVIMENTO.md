# Endless Gnome — Processo de Desenvolvimento

## Objetivo

Definir um ciclo de desenvolvimento que permita evoluir o jogo sem transformar cada nova feature em uma nova fonte de bugs.

## Ciclo padrão

```text
1. Entender
2. Documentar requisito
3. Definir contrato
4. Mapear dependências
5. Implementar núcleo mínimo
6. Testar núcleo
7. Implementar comportamento adicional
8. Testar integração
9. Atualizar documentação
10. Revisar
11. Integrar
```

## Regra 1 — Núcleo antes de comportamento

Uma entidade deve existir funcionalmente antes de receber comportamentos complexos.

Exemplo para uma aranha:

```text
Etapa A
Spider nasce
↓
Sprite aparece
↓
Collider funciona
↓
Script carrega
↓
Health/HurtBox funcionam
↓
Estado inicial funciona
```

Somente depois:

```text
Etapa B
Spider anda
↓
Etapa C
Spider detecta Player
↓
Etapa D
Spider persegue
↓
Etapa E
Spider ataca
↓
Etapa F
Spider recebe dano/morre
```

Cada etapa deve poder ser testada isoladamente.

## Regra 2 — Não adicionar complexidade sobre uma base desconhecida

Antes de adicionar uma feature, verificar:

- o arquivo que será alterado;
- a cena que o instancia;
- os componentes presentes;
- os scripts chamados;
- os sinais conectados;
- os caminhos `res://` usados;
- os contratos que serão afetados;
- os testes existentes.

## Regra 3 — Uma mudança deve possuir rastreabilidade

Cada tarefa relevante deve possuir uma referência clara:

```text
Documento
→ Issue
→ Branch
→ Commit
→ Código
→ Teste
```

Quando a alteração for significativa, registrar também o motivo da decisão.

## Regra 4 — Código não é documentação suficiente

Mesmo que o comportamento pareça óbvio no código, responsabilidades e decisões importantes devem permanecer registradas fora dele.

O código responde principalmente:

> Como está implementado?

A documentação responde:

> Por que existe, qual é o contrato e qual comportamento é esperado?

## Regra 5 — Comentários devem acompanhar o código

Ao alterar uma função ou responsabilidade, verificar se os comentários ainda descrevem o comportamento real.

Não deixar comentários que descrevem uma versão antiga do sistema.

## Regra 6 — Primeiro correção, depois refatoração

Quando um bug for encontrado:

```text
reproduzir
→ registrar
→ entender causa
→ corrigir minimamente
→ testar
→ refatorar se necessário
```

Evitar alterar dez sistemas ao mesmo tempo enquanto ainda se tenta descobrir a causa original.

## Regra 7 — Features novas precisam de critérios de aceite

Antes de implementar:

```text
O que deve acontecer?
O que não deve acontecer?
O que acontece em erro?
Como sabemos que terminou?
Como testamos?
```

## Regra 8 — Estado explícito

Sistemas complexos não devem depender de comportamento implícito espalhado em vários `if`s.

Preferir estados claros:

```text
Idle
Patrol
Chase
Attack
Hurt
Dead
```

ou equivalente documentado.

## Regra 9 — Interfaces antes de especializações

Quando vários objetos possuem o mesmo comportamento, definir primeiro um contrato comum.

Exemplo:

```text
DamageReceiver
Interactable
Collectible
```

Depois criar implementações específicas.

## Regra 10 — Testar a unidade mínima

Se uma aranha quebrar, o teste inicial não deve exigir uma fase inteira.

Criar ou usar uma cena mínima quando possível:

```text
TestSpider
├── Spider
├── TestPlayer
└── TestArena
```

Isso reduz variáveis e acelera o diagnóstico.

## Regra 11 — Documentação deve sobreviver à troca de pessoas

Uma pessoa nova deve conseguir continuar uma tarefa usando o repositório.

O conhecimento necessário não pode depender exclusivamente de quem escreveu o código original.

## Regra 12 — Documento histórico vs documento normativo

Documentos de auditoria registram o que foi encontrado.

Documentos de arquitetura/especificação registram o que deverá ser adotado.

Não misturar:

```text
"o código faz X"
```

com:

```text
"o sistema deve fazer Y"
```

sem indicar a diferença.

## Regra 13 — Definition of Done

Uma tarefa só termina quando implementação, teste e documentação correspondente estiverem coerentes.

Ver também `DEFINITION_OF_DONE.md`.

## Regra 14 — Dívida técnica visível

Quando algo precisa permanecer provisoriamente, registrar:

```text
TEMP
FIXME
DEPRECATED
TODO
```

e associar o item ao registro de problemas ou roadmap quando possível.

## Regra 15 — Não otimizar antes de medir

Performance, animação e abstrações complexas não devem ser adicionadas apenas por antecipação.

Primeiro provar necessidade, depois implementar e medir.

## Exemplo completo — Nova aranha

### Antes do código

Documento:

```text
Spider
Tipo: inimigo terrestre
Função: pressão de curto alcance

Estados:
Idle / Patrol / Detect / Chase / Attack / Hurt / Dead

Entrada:
Player em alcance de detecção

Saída:
dano / morte / recompensa
```

### Núcleo

Implementar:

```text
cena
script
sprite
collision
health
hurtbox
estado inicial
```

### Teste do núcleo

Confirmar:

```text
carrega
aparece
colide
não gera erro
pode receber dano
pode morrer
```

### Movimento

Só depois implementar:

```text
Patrol
```

### Detecção

Depois:

```text
Detect
```

### Perseguição

Depois:

```text
Chase
```

### Ataque

Depois:

```text
Attack
```

### Polimento

Só depois que o comportamento estiver estável:

```text
animação
som
partículas
telemetria visual
game feel
```

## Resultado esperado

Esse processo reduz o risco de criar uma entidade que tenha muita lógica, mas não tenha um núcleo confiável.

Também torna possível localizar o momento exato em que uma nova funcionalidade introduziu uma quebra.

## Regra final

**Toda complexidade nova deve ser construída sobre uma base que já possa ser explicada, executada e testada.**
