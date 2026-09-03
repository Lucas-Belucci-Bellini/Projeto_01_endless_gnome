# Endless Gnome — Especificação de Sistemas

## Objetivo

Este documento define o que cada sistema deve fazer antes da implementação. Serve como contrato entre planejamento, programação, design e QA.

## 1. SceneManager

Responsável por troca de cenas, transições e carregamento controlado.

### Requisitos
- receber destino válido;
- impedir chamadas duplicadas perigosas;
- permitir transição;
- registrar falhas de carregamento;
- separar cena atual de cena de destino.

## 2. GameManager

Responsável pelo estado global essencial da sessão.

Não deve concentrar toda a lógica do jogo.

Pode manter:

- estado da partida;
- fase atual;
- pausa;
- referências globais estritamente necessárias.

## 3. AudioManager

Responsável por:

- música;
- SFX;
- volume master;
- volume de música;
- volume de efeitos;
- mute;
- persistência das configurações.

A UI de configurações apenas envia comandos/valores.

## 4. Player

Responsabilidades:

- receber input;
- movimento;
- pulo;
- animação de movimento;
- solicitar ataques;
- interagir com o mundo.

Não deve implementar diretamente loja, diálogo ou regras de progressão.

## 5. Combat System

Fluxo:

```text
Input de ataque
→ criação/ativação de HitBox
→ detecção de HurtBox
→ DamageData
→ alvo processa dano
→ reação
→ morte, se aplicável
→ recompensa
```

Deve suportar expansão para diferentes armas e inimigos.

## 6. Health System

Estado:

```text
max_health
current_health
alive
invulnerable
```

Operações:

- heal;
- damage;
- reset;
- kill, quando uma regra de jogo exigir;
- is_dead.

Eventos:

- health_changed;
- damaged;
- died;
- healed.

## 7. Checkpoint/Respawn

Deve registrar um ponto válido de retorno e restaurar estado mínimo necessário.

Evitar resetar progresso persistente sem motivo.

## 8. Enemy AI

Estados mínimos:

```text
Idle
Patrol
Detect
Chase
Attack
Hurt
Dead
```

A implementação pode começar simples e evoluir por inimigo.

## 9. Crystal Pickup

Requisitos:

- detectar coleta;
- incrementar contador;
- emitir feedback;
- impedir coleta duplicada;
- informar o sistema de progressão.

## 10. MineCart

Requisitos mínimos:

- capacidade máxima;
- quantidade atual;
- aceitar cristais;
- detectar cheio;
- registrar abastecimento;
- emitir progresso;
- disparar evento ao cumprir requisito.

## 11. Objective System

Todo objetivo deve possuir estado explícito:

```text
Locked
Available
Active
Completed
Failed
```

Exemplo:

```text
"Abasteça o carrinho com 10 fragmentos"
```

O objetivo deve saber quando foi satisfeito e não depender de texto da UI para existir.

## 12. Unlock System

Permite:

- portas;
- áreas;
- mecanismos;
- conteúdo.

O requisito deve ser verificável por dados, por exemplo:

```text
required_crystals = 10
```

## 13. Interaction System

Contrato:

```text
can_interact()
interact(actor)
get_interaction_text()
```

O sistema de interação detecta o objeto, mostra o prompt e executa a ação.

## 14. Dialogue System

Componentes:

- DialogueManager;
- DialogueData;
- DialogueUI;
- Speaker.

Estados:

```text
Closed
Opening
Typing
WaitingInput
Closing
```

## 15. Puzzle System

Puzzle base deve possuir:

```text
reset()
solve()
is_solved()
```

Puzzles concretos podem ter condições próprias.

## 16. Currency System

Deve suportar pelo menos:

```text
get_balance()
add(amount)
spend(amount)
can_afford(amount)
```

Nunca permitir saldo negativo por uma compra válida.

## 17. Inventory

Responsável por itens pertencentes ao jogador.

Não deve desenhar UI.

Operações:

- add;
- remove;
- count;
- has;
- clear, se necessário.

## 18. Shop

Fluxo:

```text
Selecionar item
→ verificar moeda
→ pagar
→ adicionar item
→ emitir atualização
```

Compra deve ser transacional: não retirar moeda quando a entrega do item falhar.

## 19. Save System

Deve ser criado somente depois que os dados persistentes estiverem definidos.

Estrutura conceitual:

```text
profile
settings
progression
inventory
currency
unlocks
level_state
```

## 20. HUD

HUD deve exibir estado, não possuir o estado.

Exemplos:

- vida;
- cristais;
- moedas;
- objetivo atual.

## 21. Pause

Pause deve:

- congelar gameplay;
- manter UI responsiva;
- permitir retornar;
- permitir configurações;
- permitir abandonar/reiniciar quando definido.

## 22. Telemetria de debug

Durante desenvolvimento, pode existir logging para:

- troca de cena;
- dano;
- morte;
- objetivo;
- save/load.

Logs devem ser removíveis ou desativáveis na build final.
