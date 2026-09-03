# Endless Gnome — Auditoria Completa do Repositório

> Documento de diagnóstico. Este arquivo registra o estado encontrado no momento da auditoria e não deve ser tratado como especificação de comportamento futuro.

## 1. Escopo da auditoria

A auditoria considera o conteúdo disponível no branch principal do fork no momento da análise, incluindo estrutura do repositório, projetos Godot armazenados, scripts GDScript encontrados, cenas principais e documentação existente.

Objetivos:

- descobrir onde existem implementações duplicadas;
- identificar referências quebradas ou incompatíveis;
- diferenciar código funcional, protótipo, código morto e código experimental;
- registrar pontos que precisam ser testados em execução;
- criar uma lista rastreável de correções;
- preparar uma base segura para refatoração posterior.

## 2. Diagnóstico geral

O repositório não contém apenas uma versão única do jogo. Existem múltiplas cópias/projetos e, no mínimo, duas linhas de implementação de gameplay.

### Linha A — protótipo interno

Localizada em uma árvore com `project.godot`, `scenes/`, `scripts/` e `content/`.

Características observadas:

- `PlayerController` baseado em `CharacterBody2D`;
- movimento horizontal e pulo;
- gravidade;
- animações idle/walking;
- `HitBox` ligado ao jogador;
- inimigo com movimento simples por Timer;
- cena `world_test.tscn`;
- dois inimigos na cena de teste.

### Linha B — protótipo de combate/top-down

Localizada em `projeto-01-endless-gnome-main/`.

Características observadas:

- `Player` baseado em `CharacterBody2D`;
- movimentação em quatro direções;
- ataque por mouse;
- vida e dano;
- invulnerabilidade temporária;
- knockback;
- `HitBox`;
- `HurtBox`;
- `Enemy` com perseguição e ataque;
- câmera independente;
- posicionamento do item/arma relativo ao mouse;
- `level.tscn` integrando esses scripts.

Essas duas linhas não devem continuar evoluindo em paralelo sem uma decisão explícita.

## 3. Problemas críticos encontrados

### EG-AUD-001 — Duas implementações de Player/Enemy

**Severidade:** Crítica arquitetural.

Existem `PlayerController`/`Enemy` e também `Player`/`Enemy` em estruturas diferentes.

**Risco:** uma pessoa corrige uma versão enquanto outra pessoa utiliza a outra; alterações podem ser feitas no código que não está sendo executado pela build oficial.

**Ação:** definir uma única implementação oficial antes de novas features.

---

### EG-AUD-002 — Referências relativas dependem do projeto ativo

**Severidade:** Alta.

Os scripts usam caminhos como `res://AnimatedSprite2D`, `res://ItemPosition/WeaponHandler/HitBox` e `res://level.tscn`. Isso só funciona se a cena e a árvore forem exatamente as esperadas.

**Ação:** validar todas as referências cena ↔ script e registrar os caminhos no mapa de dependências.

---

### EG-AUD-003 — `HurtBox` e assinatura de `take_damage` são incompatíveis

**Severidade:** Crítica.

`hurt_box.gd` chama `owner.take_damage(hitbox.damage)` com um argumento, enquanto as implementações atuais de `Player.take_damage` e `Enemy.take_damage` recebem dois argumentos: quantidade e posição do atacante.

**Consequência provável:** erro em runtime quando essa rota de dano for acionada.

**Ação:** padronizar um contrato único para dano antes de integrar os sistemas.

---

### EG-AUD-004 — `world.gd` possui implementação vazia de `setup_world`

**Severidade:** Média.

`setup_world()` apenas contém `pass`.

**Ação:** decidir se é placeholder oficial ou código morto; remover ou implementar.

---

### EG-AUD-005 — arquivos temporários/versionados

**Severidade:** Alta para higiene do projeto.

Existe `level.tscn700895048.tmp`, indicando arquivo temporário salvo no repositório.

**Ação:** remover artefatos temporários e verificar outros arquivos semelhantes.

---

### EG-AUD-006 — recursos e projetos duplicados

**Severidade:** Alta.

Há ZIP, diretórios aninhados e projetos/cópias antigas.

**Ação:** catalogar cada cópia, definir origem histórica e manter apenas o conjunto necessário para desenvolvimento.

## 4. Problemas de implementação já visíveis

### Player

- `static var instance` cria acoplamento global forte.
- `queue_free()` é usado como morte final, sem ciclo de respawn.
- `take_damage()` mistura dano, flash, knockback e ciclo de invulnerabilidade.
- `attack()` procura o pai de cada área atingida e assume que ele possui `take_damage`.
- ataque usa uma HitBox fixa e o contrato de arma ainda não está formalizado.

### Enemy

- referência ao jogador depende de `Player.instance`;
- IA e combate estão no mesmo script;
- dano é aplicado diretamente ao jogador;
- ataque é ativado por distância, sem uma HitBox de ataque claramente desacoplada;
- morte não possui evento de recompensa/drop;
- não existe máquina de estados explícita.

### HitBox

- guarda dano próprio, mas não possui contrato de origem/alvo/facção;
- `monitoring = true` é definido manualmente, porém a política de collision layers/masks está espalhada pelas cenas/scripts.

### HurtBox

- configura collision layer/mask dentro do script;
- conecta sinal por `connect` em vez de conectar/organizar a arquitetura de forma consistente;
- possui incompatibilidade de assinatura com `take_damage` atual.

### ItemPosition

- depende de `get_parent().global_position`;
- posicionamento acontece em `_process`, não no ciclo de física;
- distancia e rotação ainda não estão integradas a uma abstração de arma.

### Camera

- câmera aplica zoom diretamente em `_ready`;
- não há regra documentada para limites, follow ou transição.

### Menus

- há scripts fora da estrutura do projeto principal;
- configuração de áudio ainda é parcial;
- fluxo de cenas precisa ser consolidado.

## 5. Código que precisa de revisão de contrato

Antes de implementar sistemas novos, revisar:

```text
Player.instance
Enemy.player
HitBox.damage
HurtBox._on_area_entered
Player.take_damage
Enemy.take_damage
Player.attack
Enemy.attack
Scene change
```

Cada item acima deve ter um contrato explícito.

## 6. Itens que precisam ser testados em runtime

Há problemas que a leitura estática consegue indicar, mas não consegue confirmar totalmente sem executar a cena.

Testes obrigatórios:

1. abrir a build pelo projeto oficial;
2. iniciar a cena principal;
3. entrar no nível;
4. movimentar o jogador;
5. verificar colisão;
6. atacar;
7. atingir um inimigo;
8. receber ataque;
9. verificar knockback;
10. verificar invulnerabilidade;
11. matar o inimigo;
12. morrer com o jogador;
13. reiniciar/retornar à fase;
14. abrir configurações;
15. verificar referências de cena.

## 7. Classificação de código

Cada arquivo deverá receber uma classificação depois da consolidação:

- `OFFICIAL` — participa do fluxo oficial;
- `PROTOTYPE` — útil para estudo, mas não usado pela build oficial;
- `LEGACY` — histórico, mantido apenas quando necessário;
- `DEAD` — não utilizado e candidato a remoção;
- `EXPERIMENTAL` — alteração em avaliação.

## 8. Regra de auditoria

Nenhuma refatoração grande deve ser feita antes de responder:

- qual projeto Godot é oficial?
- qual `project.godot` gera a build?
- qual Player é oficial?
- qual Enemy é oficial?
- qual Level é oficial?
- quais cenas entram na execução?
- quais scripts estão realmente anexados às cenas?

## 9. Estado da auditoria

**FASE:** diagnóstico inicial.

**Não significa:** que todos os bugs estão confirmados.

**Significa:** os pontos listados devem ser tratados como hipóteses/achados até serem validados por execução e testes.
