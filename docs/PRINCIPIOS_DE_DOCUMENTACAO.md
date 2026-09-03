# Endless Gnome — Princípios de Documentação

## 1. Objetivo

A documentação faz parte do produto de engenharia do jogo. Ela não existe apenas para explicar o projeto depois de pronto; ela existe para reduzir ambiguidades antes da implementação e preservar conhecimento durante a evolução.

## 2. Regra principal

**Antes de adicionar comportamento relevante a uma entidade ou sistema, deve existir um contrato mínimo documentado.**

Exemplo: antes de fazer uma aranha andar, devemos conseguir responder:

- O que é uma `Spider`?
- Em qual cena ela nasce?
- Qual script controla seu comportamento?
- Quais componentes ela possui?
- Qual é sua vida?
- Ela pode receber dano?
- Como detecta o jogador?
- Qual estado inicial possui?
- O que acontece quando não encontra ninguém?
- Quem pode causar dano nela?
- O que acontece quando ela morre?
- Que sinais/eventos ela emite?
- Como será testada?

Só depois disso a implementação de caminhada deve ser adicionada.

## 3. Documentação antes da feature

A ordem recomendada é:

```text
requisito
→ contrato
→ arquitetura
→ cenário de uso
→ implementação mínima
→ teste
→ implementação expandida
→ documentação atualizada
```

Isso não significa escrever centenas de páginas antes de qualquer código. Significa documentar primeiro aquilo que define interfaces, responsabilidades, estados e dependências.

## 4. O que deve ser documentado em longo prazo

### Produto

- visão do jogo;
- fantasia do jogador;
- pilares de experiência;
- escopo;
- fases;
- progressão;
- narrativa;
- objetivos;
- economia;
- critérios de qualidade.

### Arquitetura

- módulos;
- responsabilidades;
- dependências;
- comunicação entre sistemas;
- estado global;
- contratos;
- decisões arquiteturais;
- limitações conhecidas.

### Entidades

Cada entidade relevante deve possuir documentação suficiente para explicar:

- propósito;
- cena correspondente;
- script correspondente;
- componentes;
- atributos;
- estados;
- entradas;
- saídas/eventos;
- dependências;
- casos de erro;
- testes;
- evolução planejada.

### Sistemas

Cada sistema deve registrar:

- problema resolvido;
- responsabilidade;
- API/contrato;
- quem chama;
- quem consome suas saídas;
- estado mantido;
- eventos;
- casos de borda;
- critérios de aceite.

### Conteúdo

- itens;
- armas;
- inimigos;
- bosses;
- diálogos;
- puzzles;
- objetivos;
- recompensas;
- dados de fase.

## 5. Documentação no código

Comentários devem explicar intenção, contrato e riscos, e não apenas repetir a sintaxe.

Exemplo ruim:

```gdscript
velocity.x = speed
```

```gdscript
# Coloca a velocidade horizontal.
```

Exemplo útil:

```gdscript
# Aplica a velocidade horizontal definida para a entidade.
# RISCO: este valor substitui qualquer impulso horizontal existente.
# Se futuramente houver knockback, a combinação deve ser tratada por
# uma camada de movimento própria.
velocity.x = speed
```

## 6. Documentação e descoberta de bugs

Uma boa documentação não elimina bugs, mas torna mais fácil perceber quando o comportamento real diverge do contrato esperado.

Exemplo:

```text
Contrato:
Spider pode atacar somente quando o Player está no alcance.

Código:
Spider ataca imediatamente ao nascer.

Resultado:
Divergência identificável antes mesmo de uma refatoração maior.
```

## 7. Documentação como memória do projeto

O conhecimento não deve ficar somente:

- na cabeça de uma pessoa;
- em mensagens de chat;
- em commits antigos;
- em vídeos;
- em comentários vagos;
- em código difícil de interpretar.

Decisões importantes devem ser registradas no repositório.

## 8. Quando atualizar a documentação

A documentação deve ser atualizada quando:

- uma responsabilidade muda;
- um contrato muda;
- uma cena muda de função;
- um sistema é substituído;
- uma decisão arquitetural é tomada;
- um bug revela uma hipótese incorreta;
- um comportamento novo passa a ser oficial;
- uma limitação deixa de existir;
- uma feature é concluída.

## 9. Evitar documentação desatualizada

Documentação falsa é pior que ausência de documentação.

Nunca marcar uma feature como implementada somente porque existe código.

O estado deve ser baseado em evidência:

```text
PLANEJADO
→ IMPLEMENTADO
→ TESTADO
→ VALIDADO
→ OFICIAL
```

## 10. Rastreabilidade

Sempre que possível, conectar:

```text
Requisito
   ↓
Documento
   ↓
Issue
   ↓
Branch
   ↓
Commit
   ↓
Código
   ↓
Teste
   ↓
Validação
```

Isso permite descobrir por que um trecho existe e o que precisa ser revisado quando o requisito mudar.

## 11. Documentação mínima para uma nova entidade

Antes de considerar uma nova entidade pronta, deve existir pelo menos:

```text
ENTITY.md ou seção equivalente

Nome
Propósito
Cena
Script
Componentes
Estados
Atributos principais
Interações
Dano recebido
Dano causado
Eventos
Dependências
Critérios de teste
Pendências
```

## 12. Exemplo conceitual — Aranha

Uma futura `Spider` não deve começar pelo método `walk()`.

Primeiro:

```text
Spider
├── cena
├── script
├── sprite
├── collider
├── health
├── hurtbox
└── comportamento-base
```

Depois definimos:

```text
Idle
  ↓
Patrol
  ↓
Detect
  ↓
Chase
  ↓
Attack
  ↓
Hurt
  ↓
Dead
```

Só então implementamos os comportamentos, um por vez, testando a passagem entre estados.

## 13. Benefício para colaboradores

Uma pessoa nova no projeto deve conseguir responder:

> “Como eu adiciono um inimigo novo sem quebrar o jogo?”

consultando o repositório, em vez de depender de alguém explicar tudo verbalmente.

## 14. Benefício para manutenção futura

Quando o projeto crescer, o objetivo é que seja possível substituir uma implementação sem precisar reconstruir toda a lógica mental do projeto.

Exemplo:

```text
Enemy v1
   ↓
contrato documentado
   ↓
Enemy v2
```

O contrato preserva a interface enquanto a implementação evolui.

## 15. Regra desta auditoria

Durante a auditoria atual, documentar o comportamento que existe, inclusive quando estiver errado.

Durante a correção, atualizar a documentação para refletir o comportamento aprovado.

Durante o desenvolvimento futuro, documentar o contrato antes de ampliar a complexidade.

## 16. Princípio final

**Documentar cedo não significa prever tudo. Significa registrar cedo o suficiente para que as decisões importantes não dependam de memória.**
