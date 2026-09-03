# Endless Gnome — QA e Plano de Testes

## Objetivo

Encontrar regressões antes da integração e garantir que cada funcionalidade seja validada de forma repetível.

## Níveis de teste

### Smoke Test

Executado após qualquer alteração relevante.

1. Abrir projeto.
2. Rodar cena principal.
3. Verificar ausência de erro crítico.
4. Entrar no Level 01.
5. Andar e pular.
6. Interagir com pelo menos um elemento.

### Teste funcional

Valida uma mecânica isoladamente.

### Teste de integração

Valida vários sistemas juntos.

Exemplo:

```text
Enemy morreu → Crystal caiu → pickup → contador → objetivo
```

### Regressão

Reexecutar testes antigos após mudanças em sistemas compartilhados.

### Teste de build

Abrir uma build limpa em máquina/ambiente que não possui arquivos locais extras.

## Checklist de Player

- [ ] spawn correto;
- [ ] andar esquerda;
- [ ] andar direita;
- [ ] flip visual;
- [ ] parar;
- [ ] pular no chão;
- [ ] não pular infinitamente;
- [ ] gravidade;
- [ ] colisão;
- [ ] cair;
- [ ] receber dano;
- [ ] knockback;
- [ ] morrer;
- [ ] respawnar.

## Checklist de Enemy

- [ ] spawn;
- [ ] movimentação;
- [ ] mudança de direção;
- [ ] colisão;
- [ ] detectar jogador, quando aplicável;
- [ ] perseguir;
- [ ] atacar;
- [ ] receber dano;
- [ ] reação;
- [ ] morrer;
- [ ] recompensa.

## Checklist de combate

- [ ] ataque é acionado uma vez por input;
- [ ] HitBox ativa no momento correto;
- [ ] alvo recebe dano apenas quando atingido;
- [ ] dano não é aplicado em loop involuntário;
- [ ] cooldown funciona;
- [ ] invulnerabilidade funciona;
- [ ] knockback possui direção coerente;
- [ ] morte ocorre no limite correto;
- [ ] recompensa ocorre uma única vez.

## Checklist de Progressão

- [ ] cristal pode ser coletado;
- [ ] contador atualiza;
- [ ] carrinho aceita recurso;
- [ ] requisito é verificado;
- [ ] porta desbloqueia;
- [ ] objetivo conclui;
- [ ] saída libera;
- [ ] fase termina.

## Checklist de UI

- [ ] menu abre;
- [ ] Jogar funciona;
- [ ] Configurações abre;
- [ ] Voltar funciona;
- [ ] volume altera áudio;
- [ ] SFX altera efeitos;
- [ ] Pause funciona;
- [ ] HUD acompanha o estado real.

## Casos de borda

Sempre testar:

- valor zero;
- valor máximo;
- coleta duplicada;
- dano simultâneo;
- morte durante coleta;
- morte durante transição;
- reinício durante objetivo;
- troca rápida de cena;
- carregar sem save;
- save corrompido, quando o sistema existir.

## Bug report mínimo

Toda issue de bug deve conter:

```text
Título:
Ambiente:
Versão/commit:
Passos para reproduzir:
Resultado esperado:
Resultado atual:
Frequência:
Evidência:
```

## Critério de regressão

Uma alteração que quebra uma funcionalidade já aprovada não pode ser considerada pronta somente porque a nova feature funciona.
