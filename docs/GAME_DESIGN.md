# Endless Gnome — Game Design Document

## 1. Conceito

Jogo 2D de ação, aventura e exploração em ambientação subterrânea de fantasia/ficção pós-apocalíptica. O jogador controla um Gnomístico que explora áreas corrompidas e busca recuperar o poder de um cristal roubado.

## 2. Fantasia do jogador

O jogador deve sentir que:

- está explorando um mundo subterrâneo misterioso;
- cada área possui um perigo e uma descoberta;
- combate exige posicionamento e leitura de inimigos;
- recursos coletados têm utilidade concreta;
- a exploração revela partes da história;
- cada fase apresenta um objetivo claro.

## 3. Pilares de experiência

### Exploração

Descobrir caminhos, salas, artefatos, recursos e segredos.

### Combate

Ataques responsivos, leitura de alcance, dano, reação e recompensa.

### Progressão

Coletar recursos para desbloquear áreas e avançar.

### Descoberta

História apresentada por ambiente, artefatos, diálogos e eventos.

## 4. Loop principal

```text
Explorar
  ↓
Encontrar ameaça
  ↓
Combater
  ↓
Coletar recursos
  ↓
Resolver bloqueio/puzzle
  ↓
Desbloquear área
  ↓
Descobrir narrativa
  ↓
Avançar
```

## 5. Loop curto de combate

```text
Detectar inimigo
→ posicionar
→ atacar
→ confirmar impacto
→ receber/reduzir dano
→ derrotar
→ coletar recompensa
```

## 6. Regras de ouro de gameplay

- Controles devem responder rapidamente.
- Hit feedback deve existir.
- Dano não pode ser silencioso.
- Morte deve ser legível.
- Objetivos precisam ter feedback.
- Recursos precisam de propósito.
- Puzzles não devem bloquear o jogador sem indicação.

## 7. Fases

Cada fase deve possuir:

```text
Entrada
→ apresentação da mecânica
→ exploração
→ primeiro risco
→ aprofundamento
→ objetivo
→ clímax
→ conclusão
```

## 8. Level 01

O Level 01 deve ser o tutorial natural da Demo.

Ele deve ensinar, nesta ordem aproximada:

1. Movimento.
2. Pulo.
3. Ataque.
4. Dano.
5. Inimigos.
6. Coleta.
7. Objetivo.
8. Bloqueio/desbloqueio.
9. Conclusão.

Não deve exigir conhecimento externo do jogador.

## 9. Cristais

Fragmentos de cristal são o recurso temático central da progressão.

Possíveis usos:

- abastecer carrinho;
- habilitar máquinas;
- abrir portas;
- cumprir objetivos;
- liberar áreas.

Não adicionar usos aleatórios sem justificar na economia do jogo.

## 10. Moedas

Moedas devem possuir função econômica distinta dos cristais.

Regra recomendada:

- cristal = progressão/objetivo da exploração;
- moeda = economia/compras.

## 11. Loja

A loja deve aparecer quando o loop básico estiver estável.

Categorias possíveis:

- armas;
- upgrades;
- itens;
- cosméticos.

## 12. Puzzles

Puzzles devem apoiar exploração e narrativa, nunca existir apenas como obstáculo arbitrário.

Cada puzzle deve ter:

- entrada compreensível;
- feedback;
- ação do jogador;
- estado resolvido;
- consequência observável.

## 13. Inimigos

Cada inimigo precisa possuir identidade de gameplay.

Exemplo:

```text
Besouro
Função: pressão de curto alcance
```

Novos inimigos devem mudar a forma de jogar, não somente possuir mais vida.

## 14. Mini-Boss

Deve testar uma habilidade ensinada anteriormente.

Estrutura:

```text
Arena
→ apresentação
→ padrão de ataque
→ leitura
→ contra-ataque
→ mudança de fase
→ derrota
→ recompensa
```

## 15. Boss

O Boss deve ser o ápice do conteúdo da Demo.

Deve reunir sistemas anteriores, não introduzir cinco mecânicas novas simultaneamente.

## 16. Narrativa

A história deve ser modular e não obrigar o jogador a parar constantemente para ler longos textos.

Prioridade:

1. ambiente;
2. eventos;
3. artefatos;
4. diálogos curtos;
5. explicações maiores somente quando necessárias.

## 17. Acessibilidade e conforto

Itens básicos da Demo:

- remapeamento futuro, se viável;
- volume separado de música e SFX;
- texto legível;
- feedback audiovisual não exclusivo de uma única pista.

## 18. Critérios de qualidade de gameplay

Antes de considerar uma mecânica pronta, testar:

- funciona no primeiro uso;
- funciona repetidamente;
- falha de maneira controlada;
- não cria soft lock;
- apresenta feedback;
- não exige conhecimento do código.
