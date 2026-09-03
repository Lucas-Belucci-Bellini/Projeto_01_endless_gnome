# Endless Gnome — Roadmap

## Legenda

- `[ ]` não iniciado
- `[~]` em andamento
- `[x]` concluído
- `[!]` bloqueado ou requer decisão

---

## Marco 0 — Limpeza e governança

### Repositório
- [ ] Definir uma única raiz oficial do projeto Godot.
- [ ] Remover/arquivar cópias antigas do projeto.
- [ ] Retirar ZIPs redundantes do fluxo normal de desenvolvimento.
- [ ] Documentar a estrutura oficial.
- [ ] Definir política para assets de teste.

### Godot
- [ ] Renomear `config/name` para `Endless Gnome`.
- [ ] Confirmar versão da Godot usada pela equipe.
- [ ] Confirmar renderer oficial.
- [ ] Definir resolução-base e política de escalonamento.
- [ ] Confirmar input map.
- [ ] Definir cena principal oficial.

### Git
- [x] Convenções de branches documentadas.
- [x] Conventional Commits documentado.
- [ ] Criar template de Pull Request.
- [ ] Criar template de Issue.
- [ ] Definir Definition of Done.
- [ ] Definir política de revisão.

---

## Marco 1 — Vertical Slice Core

### Fluxo inicial
- [ ] Menu inicial abre.
- [ ] Jogar abre a fase oficial.
- [ ] Configurações abre.
- [ ] Voltar fecha configurações corretamente.
- [ ] Sair encerra o jogo.

### Player
- [x] Movimento horizontal prototipal.
- [x] Pulo prototipal.
- [x] Gravidade.
- [x] Animação idle.
- [x] Animação walking.
- [x] Som de pulo.
- [ ] Revisar condição de direção/flip.
- [ ] Separar movimento de combate.
- [ ] Padronizar constantes/configuração.
- [ ] Revisar knockback.

### Inimigo
- [x] Movimento básico.
- [x] Gravidade.
- [x] Patrulha simples.
- [x] HitBox de contato.
- [ ] Estado Idle.
- [ ] Estado Patrol.
- [ ] Detecção do jogador.
- [ ] Chase.
- [ ] Attack.
- [ ] Hurt.
- [ ] Death.

### Combate
- [ ] Definir interface de dano.
- [ ] Criar HealthComponent.
- [ ] Criar DamageData/contrato de dano.
- [ ] Criar sistema de invulnerabilidade.
- [ ] Criar reação ao impacto.
- [ ] Criar knockback consistente.
- [ ] Criar morte do inimigo.
- [ ] Criar feedback visual/sonoro.

### Vida e respawn
- [ ] Vida do jogador.
- [ ] Morte do jogador.
- [ ] Checkpoint.
- [ ] Respawn.
- [ ] Reinício da fase.

### UI
- [ ] HUD de vida.
- [ ] HUD de cristais.
- [ ] HUD de moedas, quando economia existir.
- [ ] Pause Menu.
- [ ] Mensagens de objetivo.

### Aceite do Marco 1
- [ ] Jogar do menu até a fase.
- [ ] Mover/pular.
- [ ] Encontrar inimigo.
- [ ] Atacar.
- [ ] Causar dano.
- [ ] Inimigo morrer.
- [ ] Jogador receber dano.
- [ ] Jogador morrer/respawnar.
- [ ] Sair/pausar sem quebrar a cena.

---

## Marco 2 — Progressão de fase

### Cristais
- [ ] Pickup de cristal.
- [ ] Contador.
- [ ] Persistência durante a fase.
- [ ] Feedback visual.

### Carrinho
- [ ] Cena própria.
- [ ] Capacidade.
- [ ] Depósito de cristais.
- [ ] Indicador de progresso.
- [ ] Condição de abastecimento.

### Portas e desbloqueios
- [ ] Sistema de requisitos.
- [ ] Porta bloqueada.
- [ ] Feedback do requisito.
- [ ] Porta desbloqueada.

### Objetivos
- [ ] Objetivo principal.
- [ ] Objetivos opcionais, se necessários.
- [ ] Estado de objetivo.
- [ ] Conclusão.
- [ ] Falha/reinício quando aplicável.

### Conclusão da fase
- [ ] Trigger de saída.
- [ ] Tela/feedback de conclusão.
- [ ] Próxima fase.

---

## Marco 3 — Interação e narrativa

### Interação
- [ ] Interactable contract.
- [ ] Prompt de interação.
- [ ] Detectar alvo.
- [ ] Executar ação.

### Diálogo
- [ ] DialogueManager.
- [ ] DialogueBox.
- [ ] Nome do personagem.
- [ ] Avanço de texto.
- [ ] Encerramento.
- [ ] Escolhas, caso façam parte da Demo.
- [ ] Dados externos/estruturados para falas.

### Lore
- [ ] Artefatos.
- [ ] Registros.
- [ ] Sistema de descoberta.
- [ ] Histórico da fase.

### Puzzles
- [ ] Base de puzzle.
- [ ] Alavanca.
- [ ] Botão/placa.
- [ ] Porta ligada ao puzzle.
- [ ] Puzzle de cristal, se necessário.

---

## Marco 4 — Economia

- [ ] CurrencyManager.
- [ ] Coins pickup.
- [ ] Inventory.
- [ ] Item data.
- [ ] Shop.
- [ ] Compra.
- [ ] Persistência.
- [ ] Armas/upgrades.
- [ ] Skins, se confirmadas no escopo.

---

## Marco 5 — Conteúdo avançado

### Inimigos
- [ ] Inimigo corpo a corpo.
- [ ] Inimigo à distância.
- [ ] Inimigo especialista.
- [ ] Elite.

### Mini-Boss
- [ ] Arena.
- [ ] Barra de vida.
- [ ] Estados.
- [ ] Ataques.
- [ ] Drops.
- [ ] Recompensa.

### Boss
- [ ] Entrada da arena.
- [ ] Fases do Boss.
- [ ] Telemetria de ataques.
- [ ] Vida.
- [ ] Morte.
- [ ] Recompensa.
- [ ] Finalização da fase.

---

## Marco 6 — Polimento

- [ ] Direção de arte consistente.
- [ ] Animações finais.
- [ ] Música.
- [ ] SFX.
- [ ] Mixagem.
- [ ] Feedback de ataque.
- [ ] Feedback de dano.
- [ ] Feedback de coleta.
- [ ] Feedback de objetivo.
- [ ] Câmera.
- [ ] Partículas.
- [ ] Transições.
- [ ] Loading, se necessário.

---

## Marco 7 — QA e release

- [ ] Teste funcional completo.
- [ ] Teste de regressão.
- [ ] Teste de controles.
- [ ] Teste de resolução.
- [ ] Teste de áudio.
- [ ] Teste de salvar/carregar.
- [ ] Teste de reinício.
- [ ] Teste de build limpa.
- [ ] Build para plataforma-alvo.
- [ ] Checklist de release.
- [ ] Versão marcada com tag.

---

## Ordem recomendada de execução

1. Organização.
2. Boot/menu/cena oficial.
3. Player.
4. Enemy.
5. Health/Damage.
6. Combat.
7. Death/Respawn.
8. HUD/Pause.
9. Crystal.
10. MineCart.
11. Objectives/Level Complete.
12. Interaction.
13. Dialogue.
14. Puzzles.
15. Economy.
16. Mini-Boss.
17. Boss.
18. Polish.
19. QA.
20. Release.
