# Endless Gnome — Animação e Polimento

## Objetivo

Registrar uma frente futura dedicada à qualidade visual e à sensação de movimento do jogo. Esta frente não faz parte da primeira rodada de correções estruturais.

O objetivo é deixar movimentos, ataques, impactos, transições e comportamentos visuais mais naturais, legíveis e consistentes.

## Regra de ordem

A animação não deve ser usada para mascarar bugs de lógica, colisão, física, estados ou sincronização.

A ordem planejada é:

```text
estabilizar lógica
→ estabilizar estados
→ estabilizar colisões
→ estabilizar combate
→ validar fluxo de jogo
→ revisar animação
→ polir apresentação
```

## O que deve ser analisado futuramente

### Player

- idle;
- caminhada/corrida;
- salto;
- queda;
- ataque;
- preparação do ataque;
- recuperação do ataque;
- dano;
- knockback;
- morte;
- transições entre estados;
- direção do personagem;
- sincronização entre arma, hitbox e animação.

### Inimigos

- idle;
- patrulha;
- perseguição;
- ataque;
- antecipação do ataque;
- impacto;
- dano;
- knockback;
- morte;
- transições de estado.

### Ambiente

- elementos animados;
- efeitos de cristal;
- portas;
- mecanismos;
- carrinho de mineração;
- partículas;
- feedback de interação.

### UI

- transições;
- feedback de dano;
- coleta de recursos;
- objetivo concluído;
- abertura/fechamento de menus;
- feedback de botões;
- HUD.

## Naturalidade do movimento

A revisão futura deve observar especialmente:

- aceleração e desaceleração;
- tempo de antecipação;
- tempo de impacto;
- tempo de recuperação;
- continuidade entre animações;
- coerência entre movimento físico e movimento visual;
- leitura clara para o jogador;
- ausência de mudanças bruscas não intencionais.

## Uso de ferramentas e assistência

Esta frente pode ser realizada em colaboração com uma pessoa especializada em animação/game feel, Claude Code ou outra IA/ferramenta capaz de analisar e editar a implementação.

A ferramenta não deve substituir validação humana. Alterações de animação precisam ser testadas dentro do jogo, porque timing, colisão, sprite, áudio e gameplay dependem uns dos outros.

## Separação entre bug e polimento

Durante a auditoria, registrar separadamente:

### Bug funcional

O jogo se comporta incorretamente segundo o requisito.

Exemplo:

```text
ataque causa dano mesmo quando a animação não chegou ao ponto de impacto
```

### Problema visual

A lógica funciona, mas o resultado visual é ruim.

Exemplo:

```text
transição idle → caminhada parece instantânea demais
```

### Melhoria de game feel

A lógica e o visual funcionam, mas a experiência pode ficar mais natural.

Exemplo:

```text
adicionar antecipação antes do ataque e recuperação após o golpe
```

## Critérios de aceite futuros

Uma animação revisada deve:

- corresponder ao estado real da entidade;
- não criar janelas incorretas de colisão ou dano;
- manter direção consistente;
- não interromper estados críticos de forma indevida;
- possuir transições previsíveis;
- ser testável em diferentes velocidades e situações;
- não introduzir dependência desnecessária entre gameplay e apresentação.

## Registro de origem

Qualquer melhoria feita com ajuda externa deve registrar:

- ferramenta/pessoa utilizada;
- arquivos alterados;
- objetivo da alteração;
- problema anterior;
- resultado observado;
- testes realizados.

Isso permite revisar a alteração depois e evita que uma mudança visual esconda uma regressão de gameplay.

## Estado atual

**PLANEJADO — NÃO IMPLEMENTAR NESTA FASE.**

Primeiro concluir auditoria, mapeamento de dependências, diagnóstico e correções estruturais. Depois abrir uma rodada específica de animação e game feel.
