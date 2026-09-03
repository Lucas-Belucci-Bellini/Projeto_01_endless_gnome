# Endless Gnome — Diagnóstico de Runtime

## Objetivo

Descobrir em qual etapa do fluxo o projeto quebra, sem misturar diagnóstico com correção.

## Regra principal

A primeira execução deve responder **onde quebra**, não tentar resolver tudo de uma vez.

Fluxo:

```text
abre projeto
  ↓
carrega projeto Godot
  ↓
carrega cena principal
  ↓
menu
  ↓
Level
  ↓
Player
  ↓
Enemy
  ↓
ataque
  ↓
HurtBox
  ↓
dano
  ↓
knockback
  ↓
morte
```

## Passo 0 — Ambiente

Registrar:

- versão do Godot usada;
- sistema operacional;
- branch/commit testado;
- projeto aberto pelo caminho oficial;
- mensagens do Output/Debugger.

## Passo 1 — Abrir o projeto

Resultado esperado:

- projeto abre sem erro de importação;
- todos os assets são encontrados;
- nenhum script apresenta erro de parsing.

Anotar qualquer erro exatamente como aparece.

## Passo 2 — Cena principal

Verificar:

- qual `run/main_scene` está configurado;
- se o arquivo existe;
- se a UID aponta para uma cena válida;
- se todos os recursos referenciados carregam.

## Passo 3 — Tela inicial

Testar:

- botão Jogar;
- botão Configurações;
- botão Sair;
- retorno das configurações.

Pontos de atenção:

- caminhos `res://...`;
- cenas instanciadas;
- sinais dos botões.

## Passo 4 — Level

Ao entrar no nível, confirmar:

- jogador nasce;
- câmera está correta;
- mapa aparece;
- colisões funcionam;
- inimigos existem;
- nenhum erro aparece ao instanciar nós.

## Passo 5 — Movimento

Testar individualmente:

- cima;
- baixo;
- esquerda;
- direita;
- diagonal;
- colisão;
- movimento com knockback.

## Passo 6 — Ataque do jogador

Testar:

1. clicar sem inimigo;
2. clicar perto do inimigo;
3. clicar dentro do alcance;
4. clicar repetidamente;
5. verificar cooldown;
6. verificar se o alvo recebe dano somente uma vez por ataque.

Registrar:

- quantidade de áreas retornadas por `get_overlapping_areas()`;
- alvo selecionado por `area.get_parent()`;
- existência de `take_damage`;
- erro de assinatura, se houver.

## Passo 7 — Dano pelo HurtBox

Este é um ponto prioritário.

A chamada observada é:

```gdscript
owner.take_damage(hitbox.damage)
```

Enquanto o contrato atual das entidades é:

```gdscript
func take_damage(amount: int, attacker_pos: Vector2):
```

O teste deve confirmar se esse caminho é executado e registrar o erro exato.

## Passo 8 — Ataque do inimigo

Testar:

- inimigo encontra Player;
- persegue;
- para ao aproximar;
- ataca;
- respeita cooldown;
- causa dano;
- reage ao knockback.

## Passo 9 — Morte

Testar separadamente:

- inimigo chega a zero de vida;
- jogador chega a zero de vida;
- animação/evento de morte;
- retorno/respawn, quando implementado.

No estado atual, `queue_free()` é usado diretamente. Isso deve ser registrado como comportamento observado, não como design final.

## Passo 10 — Pós-diagnóstico

Depois de encontrar o primeiro erro crítico:

1. registrar no `REGISTRO_DE_PROBLEMAS.md`;
2. não corrigir outros problemas não relacionados no mesmo commit;
3. criar branch de correção específica;
4. implementar correção mínima;
5. repetir o smoke test;
6. registrar o resultado.

## Matriz de observação

| Etapa | Esperado | Observado | Erro/log | Status |
|---|---|---|---|---|
| Abrir projeto | Projeto carrega | — | — | PENDING |
| Cena principal | Cena carrega | — | — | PENDING |
| Menu | Botões respondem | — | — | PENDING |
| Level | Player/Enemy carregam | — | — | PENDING |
| Movimento | Player move | — | — | PENDING |
| Ataque | Dano é aplicado | — | — | PENDING |
| HurtBox | Dano processado | — | — | PENDING |
| Enemy | Persegue/ataca | — | — | PENDING |
| Morte | Estado final correto | — | — | PENDING |

## Importante

Falha de execução deve ser reproduzida no menor cenário possível. Quanto menor o caso que reproduz o erro, mais fácil é identificar sua causa.
