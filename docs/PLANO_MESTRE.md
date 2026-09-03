# Endless Gnome — Plano Mestre

> Documento central de planejamento do projeto.
>
> Objetivo: transformar o protótipo atual em uma Demo jogável, coesa, testável e organizada, sem tentar implementar tudo ao mesmo tempo.

## 1. Visão do projeto

Endless Gnome é um jogo 2D desenvolvido na Godot Engine, combinando plataforma, exploração, combate, puzzles e progressão. O núcleo narrativo envolve os Gnomísticos, um cristal roubado e a corrupção da vida subterrânea.

A documentação atual descreve como pilares: exploração, combate, fragmentos de cristal, carrinho de mineração, puzzles, moedas, loja, mini-bosses, boss e descoberta gradual da história.

## 2. Estado atual identificado

O repositório contém uma base jogável/prototípica de personagem, inimigo, cena de teste, assets e telas de título/configuração. Também contém documentação de versionamento.

Principais pontos técnicos encontrados:

- Existem múltiplas cópias/projetos dentro do repositório.
- Existem pelo menos duas linhas de implementação de gameplay.
- Uma linha trabalha com plataforma/pulo e `PlayerController`.
- Outra linha trabalha com movimentação top-down, `Player`, `Enemy`, `HitBox` e `HurtBox`.
- Existem referências e contratos que ainda precisam ser consolidados.
- Existem pontos de comportamento ainda não validados em runtime.

## 3. Objetivo da auditoria atual

Antes de ampliar o conteúdo, descobrir como o projeto realmente funciona.

A sequência desta etapa é:

```text
mapear repositório
→ mapear projetos
→ mapear cenas
→ mapear scripts
→ mapear dependências
→ comentar código
→ identificar contratos
→ encontrar divergências
→ testar runtime
→ registrar problemas
```

Nenhum bug deve ser apagado durante a investigação sem registrar primeiro a evidência e a causa provável.

## 4. Princípio de documentação de longo prazo

Documentação é parte da engenharia do jogo.

Antes de adicionar comportamento relevante a uma entidade ou sistema, deve existir um contrato mínimo documentado.

A regra é:

```text
requisito
→ contrato
→ arquitetura
→ núcleo mínimo
→ teste
→ comportamento adicional
→ teste
→ integração
→ documentação final
```

Não é necessário prever tudo antecipadamente. É necessário registrar cedo as decisões que criam dependências.

## 5. Exemplo de evolução de entidade

Uma nova entidade, como uma aranha, não deve começar pelo comportamento mais visível.

Primeiro:

```text
Spider
├── cena
├── script
├── sprite
├── collider
├── estado inicial
└── componentes básicos
```

Depois:

```text
Health/HurtBox
→ teste
→ Idle
→ teste
→ Patrol
→ teste
→ Detect
→ teste
→ Chase
→ teste
→ Attack
→ teste
→ Death
→ teste
```

Somente depois:

```text
animação final
som
partículas
game feel
```

Ver `ESPECIFICACAO_DE_ENTIDADE.md` e `PROCESSO_DE_DESENVOLVIMENTO.md`.

## 6. Fases macro

### Fase 0 — Auditoria e organização

- Definir diretório oficial do projeto Godot.
- Catalogar todas as cópias.
- Identificar projeto ativo.
- Identificar `project.godot` oficial.
- Identificar Player oficial.
- Identificar Enemy oficial.
- Identificar Level oficial.
- Mapear cenas e scripts.
- Validar referências `res://`.
- Documentar collision layers/masks.
- Registrar sinais e contratos.
- Remover ambiguidades arquiteturais somente depois da auditoria.

### Fase 1 — Fundação jogável

- Cena inicial oficial.
- Level 01 oficial.
- Player estável.
- Enemy estável.
- Health/Damage.
- Combat.
- Death/Respawn.
- HUD mínimo.
- Pause.

### Fase 2 — Progressão

- Crystal Fragment.
- Objetivos de fase.
- MineCart.
- Unlock de portas/áreas.
- Checkpoint.
- Conclusão de Level 01.

### Fase 3 — Interação e narrativa

- Interaction system.
- Dialogue system.
- Artefatos.
- Lore.
- Puzzles.

### Fase 4 — Economia

- Coins.
- Inventory.
- Shop.
- Weapons/upgrades.
- Skins, caso estejam dentro do escopo da Demo.

### Fase 5 — Conteúdo de combate

- Tipos adicionais de inimigo.
- Elite.
- Mini-Boss.
- Boss.
- Drops e recompensas.

### Fase 6 — Polimento

- UI final.
- Áudio.
- Feedback visual.
- Balanceamento.
- Performance.
- Acessibilidade básica.
- Animações finais.
- Game feel.
- Build da Demo.

### Fase 7 — QA e release

- Teste funcional completo.
- Teste de regressão.
- Teste de controles.
- Teste de resolução.
- Teste de áudio.
- Teste de salvar/carregar.
- Teste de reinício.
- Teste de build limpa.
- Build para plataforma-alvo.
- Checklist de release.
- Versão marcada com tag.

## 7. Critérios para considerar a Demo pronta

A Demo só deve ser considerada pronta quando:

- Abre pela tela inicial sem referências quebradas.
- Jogador entra em uma fase oficial.
- Movimento, pulo e colisão funcionam.
- Combate funciona de forma previsível.
- Dano, morte e retorno/respawn funcionam.
- Pelo menos uma forma de progressão está implementada.
- Pelo menos um objetivo é concluível.
- Existe condição clara de conclusão da fase.
- O jogo não depende de arquivos de teste esquecidos.
- Não há erros críticos conhecidos.
- O projeto pode ser clonado e aberto por outro integrante seguindo a documentação.
- Cada sistema crítico possui contrato e teste documentados.

## 8. Fora do caminho crítico inicial

Os seguintes itens não devem bloquear o primeiro vertical slice:

- grande quantidade de inimigos;
- loja completa;
- grande árvore de upgrades;
- múltiplos biomas;
- lore extensa;
- sistemas de personalização complexos;
- multiplayer;
- otimizações prematuras;
- animação final antes da estabilidade funcional.

## 9. Definição de pronto global

Uma tarefa é considerada DONE quando:

1. O requisito foi implementado.
2. A cena/script correto é utilizado.
3. Não há referência quebrada introduzida pela alteração.
4. O comportamento foi testado.
5. Documentação relevante foi atualizada.
6. O commit segue o padrão do projeto.
7. O branch pode ser revisado e integrado sem trabalho escondido.
8. O comentário/documentação do código continua verdadeiro.

## 10. Regra de evolução

O projeto deve crescer por ciclos curtos:

**planejar → implementar → testar → documentar → revisar → integrar**.

Nunca considerar “código escrito” igual a “feature pronta”.

Nunca considerar “documentado” igual a “funcional”.

## 11. Ordem da atual auditoria

```text
1. Inventário do repositório
2. Mapa de código
3. Mapa de cenas
4. Mapa de dependências
5. Comentação dos scripts
6. Contratos de entidades e sistemas
7. Registro de problemas
8. Diagnóstico de runtime
9. Decisão de arquitetura oficial
10. Correções mínimas
11. Regressão
12. Refatoração
13. Features novas
14. Polimento/animação
15. Release
```

## 12. Regra final

**Primeiro precisamos conseguir explicar o jogo inteiro. Depois precisamos conseguir executá-lo de forma previsível. Só então precisamos fazê-lo crescer.**
