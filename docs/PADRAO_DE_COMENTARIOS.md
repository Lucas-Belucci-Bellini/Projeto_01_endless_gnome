# Endless Gnome — Padrão de Comentários e Auditoria de Código

## Objetivo

Os comentários do projeto não devem apenas explicar sintaxe. Eles devem ajudar outro desenvolvedor a entender a intenção, as dependências, as invariantes e os riscos de cada trecho.

## 1. Cabeçalho de script

Todo script relevante deve iniciar com uma seção curta informando:

```gdscript
# RESPONSABILIDADE:
# O que este script controla.
#
# DEPENDÊNCIAS:
# Nós, classes, sinais ou sistemas externos necessários.
#
# CONTRATO:
# O que entra e o que sai.
#
# RISCOS CONHECIDOS:
# Condições que podem causar erro ou comportamento inesperado.
#
# STATUS:
# OFFICIAL | PROTOTYPE | LEGACY | EXPERIMENTAL
```

## 2. Comentários de fluxo

Comentar trechos quando a intenção não for óbvia.

Bom:

```gdscript
# O knockback é somado à velocidade normal para que o empurrão
# afete a movimentação sem substituir o estado de controle.
```

Ruim:

```gdscript
# soma velocity
velocity += knockback_velocity
```

O comentário deve explicar o motivo, não repetir a linha.

## 3. Comentários de risco

Quando um trecho depende de alguma condição estrutural, registrar explicitamente:

```gdscript
# RISCO: este caminho pressupõe que o nó `HitBox` exista exatamente
# neste local na cena. Uma renomeação da árvore quebra a referência.
```

## 4. Comentários de contrato

Métodos públicos ou acessados por outros sistemas devem registrar a expectativa:

```gdscript
# Recebe a quantidade de dano e a origem do impacto.
# A origem é necessária para calcular a direção do knockback.
func take_damage(amount: int, attacker_pos: Vector2):
```

## 5. Não mascarar problemas

Não usar comentários como justificativa para código incorreto.

Evitar:

```gdscript
# gambiarra necessária
```

Preferir:

```gdscript
# TODO(EG-AUD-003): esta chamada precisa ser migrada para o contrato
# único de dano antes da integração do sistema de combate.
```

## 6. Marcadores de auditoria

Usar estes marcadores durante a investigação:

- `TODO` — trabalho planejado.
- `FIXME` — comportamento incorreto conhecido.
- `BUG` — bug confirmado/reproduzido.
- `RISK` — ponto com possibilidade real de falha.
- `ASSUMPTION` — hipótese usada pelo código.
- `DEPRECATED` — API ou implementação que será substituída.
- `TEMP` — solução temporária.
- `TEST` — ponto que precisa de validação.

## 7. Regra de comentários em código legado

Na primeira passagem, não reescrever a lógica somente para deixar o código bonito.

A sequência deve ser:

```text
ler → comentar → identificar risco → testar → corrigir → refatorar
```

Isso evita misturar descoberta de bugs com refatoração e perder a origem de uma regressão.

## 8. Comentário por arquivo

Durante a auditoria, cada arquivo deve responder:

1. Para que serve?
2. Quem instancia?
3. De quem depende?
4. Quem depende dele?
5. Quais sinais chama/recebe?
6. Qual estado mantém?
7. O que pode quebrar?
8. O que deveria ser feito depois?

## 9. Comentário de máquina de estados

Quando um sistema tiver estados, comentar transições importantes:

```text
Idle → Chase quando o player entra no alcance.
Chase → Attack quando distância <= alcance de ataque.
Attack → Chase após o cooldown.
Qualquer estado → Dead quando vida <= 0.
```

## 10. Proibição de comentário enganoso

Nunca descrever comportamento que o código não garante.

Se o comportamento é desconhecido, escrever:

```gdscript
# TEST: comportamento precisa ser confirmado em runtime.
```

## 11. Objetivo da instrumentação

Ao final da primeira passagem, deve ser possível seguir o caminho:

```text
Input
 ↓
Cena
 ↓
Entidade
 ↓
HitBox/HurtBox
 ↓
Dano
 ↓
Estado
 ↓
Evento
 ↓
UI/Progressão
```

sem precisar adivinhar onde uma responsabilidade está escondida.
