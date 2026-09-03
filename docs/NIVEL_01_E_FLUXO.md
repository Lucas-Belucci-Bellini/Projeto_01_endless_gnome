# Endless Gnome — Level 01 e Fluxo Principal

## Objetivo do primeiro nível

O Level 01 é o campo de validação do projeto. Ele deve provar que a arquitetura e o loop principal funcionam antes da expansão para novas áreas.

## Fluxo do nível

```text
START
 ↓
Introdução curta
 ↓
Área segura
 ↓
Ensino de movimento
 ↓
Primeiro inimigo
 ↓
Ensino de combate
 ↓
Coleta de cristais
 ↓
Primeiro bloqueio
 ↓
Puzzle/objetivo simples
 ↓
Carrinho
 ↓
Área de maior risco
 ↓
Checkpoint
 ↓
Clímax de combate
 ↓
Saída
 ↓
Conclusão do nível
```

## Área A — Entrada

Objetivo: familiarizar com controles.

Conteúdo:

- spawn do jogador;
- área segura;
- indicação de movimento;
- pequena plataforma/obstáculo.

Não colocar ameaça grave aqui.

## Área B — Primeiro combate

Objetivo: ensinar ataque e dano.

Conteúdo:

- um inimigo;
- espaço suficiente para movimentação;
- feedback de dano;
- recompensa simples.

## Área C — Coleta

Introduzir fragmentos de cristal.

O jogador deve perceber:

```text
inimigos → recompensa → recurso → objetivo
```

## Área D — Bloqueio

Uma passagem deve exigir uma condição já ensinada.

Exemplo:

```text
Porta
requisito: 5 fragmentos
```

O jogo deve informar por que a porta não abre.

## Área E — Carrinho

Primeira utilização do carrinho de mineração.

O jogador deposita os cristais e observa um progresso claro.

## Área F — Intensificação

A dificuldade sobe por combinação de elementos conhecidos, não por mecânicas novas aleatórias.

Pode incluir:

- mais inimigos;
- espaço de combate diferente;
- pequeno puzzle;
- plataforma mais exigente.

## Área G — Checkpoint

O jogador encontra um ponto de retorno antes do clímax.

## Área H — Clímax

Uma arena pequena testa:

- movimentação;
- combate;
- leitura de inimigo;
- uso de recursos.

Não precisa ser o Boss final nesta primeira implementação.

## Área I — Saída

A saída é liberada quando o objetivo principal estiver concluído.

Ao entrar:

```text
LevelComplete
 ↓
resultado
 ↓
próximo destino/menu
```

## Critérios de level design

### Legibilidade

O jogador deve entender onde pode ir e qual é o objetivo imediato.

### Ritmo

Alternar exploração, combate e resolução de objetivo.

### Segurança

Checkpoint deve existir antes de uma sequência que possa exigir repetição.

### Recompensa

Exploração opcional deve ter recompensa proporcional, sem tornar o caminho principal confuso.

## Casos de falha

Testar:

- jogador cai;
- jogador morre;
- jogador reinicia;
- inimigo morre antes do objetivo;
- jogador coleta recurso e morre;
- jogador tenta abrir porta sem requisito;
- jogador conclui requisito e retorna;
- jogador entra na saída várias vezes.

## Proibição inicial

Não usar `world_test.tscn` como nome final da fase. O protótipo pode continuar existindo temporariamente como sandbox, mas a Demo deve possuir uma cena oficial e documentada.
