# Endless Gnome — Registro de Problemas

> Registro operacional. Um item entra aqui quando há evidência no código/documentação ou quando um teste reproduz o problema.

## Status permitidos

- `OPEN` — problema aberto.
- `INVESTIGATING` — investigação em andamento.
- `CONFIRMED` — problema reproduzido/confirmado.
- `FIXED` — corrigido, aguardando regressão.
- `VERIFIED` — corrigido e validado.
- `WONTFIX` — decidido não corrigir.
- `DUPLICATE` — coberto por outro item.

## Prioridades

- `P0` — impede execução, integração ou fluxo básico.
- `P1` — quebra sistema importante ou gera comportamento incorreto recorrente.
- `P2` — problema relevante, mas sem bloquear o desenvolvimento.
- `P3` — melhoria, limpeza ou polimento.

## Problemas conhecidos

| ID | Prioridade | Status | Área | Problema | Próxima ação |
|---|---|---|---|---|---|
| EG-AUD-001 | P0 | OPEN | Arquitetura | Existem duas linhas de gameplay (`PlayerController`/`Enemy` e `Player`/`Enemy`). | Escolher implementação oficial. |
| EG-AUD-002 | P0 | OPEN | Cenas | Referências `res://` precisam ser validadas contra a árvore real de cada cena. | Fazer mapa cena/script. |
| EG-AUD-003 | P0 | OPEN | Combate | `HurtBox` passa 1 argumento para `take_damage`, mas as implementações atuais esperam 2. | Padronizar contrato de dano. |
| EG-AUD-004 | P2 | OPEN | World | `setup_world()` contém apenas `pass`. | Decidir remover ou implementar. |
| EG-AUD-005 | P1 | OPEN | Repositório | Arquivo temporário `level.tscn700895048.tmp` está versionado. | Remover e procurar outros temporários. |
| EG-AUD-006 | P1 | OPEN | Repositório | Existem ZIPs, cópias e diretórios de projetos antigos. | Catalogar e consolidar. |
| EG-AUD-007 | P1 | OPEN | Player | `Player.instance` cria dependência global rígida. | Avaliar GameManager/registro de entidades. |
| EG-AUD-008 | P1 | OPEN | Player | `queue_free()` é usado diretamente como morte, sem ciclo de respawn. | Criar Death/Respawn. |
| EG-AUD-009 | P1 | OPEN | Combat | Ataque procura `get_parent()` das áreas atingidas e pressupõe `take_damage`. | Criar contrato explícito de alvo. |
| EG-AUD-010 | P1 | OPEN | Enemy | IA, ataque, dano e morte estão concentrados no mesmo script. | Separar responsabilidades gradualmente. |
| EG-AUD-011 | P2 | OPEN | Item | `ItemPosition` atualiza posição em `_process`. | Avaliar sincronização com física/arma. |
| EG-AUD-012 | P1 | OPEN | UI | Configurações têm botões de volume/SFX, mas comportamento ainda não está fechado. | Criar AudioManager. |
| EG-AUD-013 | P1 | OPEN | Testes | Não há evidência de suíte automatizada para o gameplay. | Definir smoke/functional tests e executar. |
| EG-AUD-014 | P1 | OPEN | Projeto | A linha antiga usa configuração própria (`primeiro projeto gnomo`) e outra versão de Godot, aumentando risco de incompatibilidade. | Definir projeto/versão oficial. |

## Regras de atualização

Ao encontrar um novo problema:

1. dar um ID único;
2. registrar evidência;
3. indicar prioridade;
4. definir reprodução, quando aplicável;
5. não marcar como `VERIFIED` sem teste.

## Evidência por código

### EG-AUD-003

`hurt_box.gd` chama `owner.take_damage(hitbox.damage)`. As versões atuais de `Player.take_damage` e `Enemy.take_damage` recebem `amount` e `attacker_pos`.

### EG-AUD-007

`Player` guarda uma instância estática global e `Enemy` depende dela para encontrar o jogador.

### EG-AUD-008

`Player.take_damage()` chama `queue_free()` ao zerar a vida.

### EG-AUD-009

`Player.attack()` usa `area.get_parent()` e chama `take_damage` diretamente.

### EG-AUD-012

A cena de configurações possui opções de `VOLUME` e `SFX`, mas o script atualmente trata apenas o retorno.

## Próxima etapa

Este registro será atualizado durante a instrumentação/comentação do código e durante os testes de execução.
