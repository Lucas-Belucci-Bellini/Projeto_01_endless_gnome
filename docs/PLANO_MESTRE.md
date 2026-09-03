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

- Projeto Godot 4.4.
- Cena de teste com jogador, TileMap, câmera e dois inimigos.
- Jogador baseado em CharacterBody2D.
- Movimento horizontal, pulo, gravidade e animações idle/walking.
- HitBox do jogador e HitBox do inimigo.
- Inimigo com patrulha simples baseada em Timer.
- Tela de título criada, mas o fluxo para a cena de jogo precisa ser consolidado.
- Menu de configurações iniciado, porém volume/SFX ainda não estão implementados.
- Estrutura de arquivos possui cópias/projetos antigos e um ZIP do projeto.
- O nome configurado no project.godot ainda é genérico ("package").

## 3. Objetivo da primeira fase

Antes de ampliar o conteúdo, fechar um vertical slice mínimo:

Menu → Level 01 → movimentação → combate → dano → morte → recompensa → objetivo → conclusão da fase.

Essa sequência passa a ser o contrato mínimo de uma Demo funcional.

## 4. Princípios

### 4.1 Primeiro estabilidade, depois conteúdo

Não adicionar Boss, loja, vários níveis ou sistemas paralelos enquanto o loop básico não estiver confiável.

### 4.2 Uma responsabilidade por sistema

Cada sistema deve ter um objetivo claro. Evitar colocar vida, combate, UI e progressão dentro do mesmo script.

### 4.3 Cenas reutilizáveis

Player, Enemy, portas, itens, pickups, UI e componentes de gameplay devem ser reutilizáveis em diferentes fases.

### 4.4 Tudo que entra no jogo precisa ser testável

Toda mecânica nova deve vir com critérios de aceite e um teste manual mínimo. Sistemas críticos devem ganhar testes automatizados quando viável.

### 4.5 Main deve permanecer estável

O trabalho normal acontece em branches. A main representa o estado integrado do projeto.

## 5. Fases macro

### Fase 0 — Organização

- Definir diretório oficial do projeto Godot.
- Eliminar ambiguidade entre cópias antigas, ZIPs e projeto oficial.
- Padronizar nome do projeto.
- Definir convenções de cena, script, assets e branches.
- Registrar dívida técnica.

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
- Build da Demo.

## 6. Critérios para considerar a Demo pronta

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

## 7. Fora do caminho crítico inicial

Os seguintes itens não devem bloquear o primeiro vertical slice:

- grande quantidade de inimigos;
- loja completa;
- grande árvore de upgrades;
- múltiplos biomas;
- lore extensa;
- sistemas de personalização complexos;
- multiplayer;
- otimizações prematuras.

## 8. Definição de pronto global

Uma tarefa é considerada DONE quando:

1. O requisito foi implementado.
2. A cena/script correto é utilizado.
3. Não há referência quebrada introduzida pela alteração.
4. O comportamento foi testado.
5. Documentação relevante foi atualizada.
6. O commit segue o padrão do projeto.
7. O branch pode ser revisado e integrado sem trabalho escondido.

## 9. Regra de evolução

O projeto deve crescer por ciclos curtos:

**planejar → implementar → testar → documentar → revisar → integrar**.

Nunca considerar “código escrito” igual a “feature pronta”.
