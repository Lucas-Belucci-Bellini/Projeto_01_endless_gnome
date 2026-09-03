# Documentação do Endless Gnome

Esta pasta concentra a documentação de planejamento, arquitetura, auditoria, desenvolvimento e evolução de longo prazo.

## Documentos principais

- [Plano Mestre](PLANO_MESTRE.md) — direção geral e ordem de execução.
- [Roadmap](ROADMAP.md) — backlog por marcos.
- [Game Design](GAME_DESIGN.md) — visão e regras de experiência do jogo.
- [Arquitetura](ARQUITETURA.md) — organização técnica e responsabilidades.
- [Especificação de Sistemas](ESPECIFICACAO_SISTEMAS.md) — contrato esperado para cada sistema.
- [Especificação de Entidades](ESPECIFICACAO_DE_ENTIDADE.md) — modelo para documentar Players, inimigos, NPCs e objetos antes de ampliar comportamento.
- [Processo de Desenvolvimento](PROCESSO_DE_DESENVOLVIMENTO.md) — ciclo recomendado para criar, testar e integrar funcionalidades.
- [Princípios de Documentação](PRINCIPIOS_DE_DOCUMENTACAO.md) — política de documentação de curto e longo prazo.
- [Level 01 e Fluxo](NIVEL_01_E_FLUXO.md) — desenho da primeira experiência jogável.
- [QA e Testes](QA_E_TESTES.md) — estratégia de validação.
- [Definition of Done](DEFINITION_OF_DONE.md) — critérios para encerrar tarefas.
- [Auditoria Completa](AUDITORIA_COMPLETA.md) — diagnóstico técnico do estado encontrado.
- [Mapa de Código](MAPA_DE_CODIGO.md) — relação arquivo → responsabilidade → dependências.
- [Registro de Problemas](REGISTRO_DE_PROBLEMAS.md) — backlog de problemas confirmados ou em investigação.
- [Padrão de Comentários](PADRAO_DE_COMENTARIOS.md) — padrão usado para instrumentar o código durante a auditoria.
- [Diagnóstico de Runtime](DIAGNOSTICO_RUNTIME.md) — roteiro para reproduzir as falhas em execução.
- [Animação e Polimento](ANIMACAO_E_POLIMENTO.md) — frente futura de animação, naturalidade e game feel.

## Filosofia do projeto

A documentação não é uma etapa burocrática colocada depois do código. Ela é parte do desenvolvimento.

Antes de ampliar um sistema relevante, o projeto deve conseguir explicar:

```text
O que existe?
Por que existe?
Qual é o contrato?
Quem depende disso?
O que pode quebrar?
Como será testado?
```

Uma entidade nova deve primeiro possuir um núcleo funcional e documentado. Depois recebe comportamentos adicionais, um por vez.

Exemplo:

```text
Spider
→ cena/script
→ núcleo funcional
→ estado inicial
→ Health/HurtBox
→ teste
→ movimento
→ teste
→ detecção
→ teste
→ perseguição
→ teste
→ ataque
→ teste
→ polimento
```

## Fluxo de trabalho

### 1. Entender

Ler a documentação do requisito antes de programar.

### 2. Auditar

Verificar código, cenas, referências, dependências e problemas conhecidos.

### 3. Planejar

Registrar a alteração no roadmap/issue e definir critérios de aceite.

### 4. Definir contrato

Documentar responsabilidade, estado, entradas, saídas e dependências antes da implementação relevante.

### 5. Implementar

Trabalhar em branch específica, evitando misturar correção, refatoração e feature sem necessidade.

### 6. Testar

Executar smoke test, teste funcional e regressão dos sistemas afetados.

### 7. Documentar

Atualizar arquitetura, problemas, roadmap, entidade/sistema e comentários relevantes.

### 8. Revisar

Abrir Pull Request com evidências do teste e impacto da mudança.

## Fonte da verdade

O código é a fonte da verdade para o comportamento que realmente existe.

A documentação é a fonte da verdade para requisitos, decisões e estado planejado.

Quando código e documentação divergirem, a divergência deve ser registrada e resolvida deliberadamente.

## Regra desta fase de auditoria

Durante a primeira passagem, comentários e documentação devem explicar o código existente sem esconder problemas e, sempre que possível, sem alterar a lógica. Correções entram em mudanças separadas para preservar a causa original dos bugs.
