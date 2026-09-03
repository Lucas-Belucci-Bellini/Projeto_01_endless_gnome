# Documentação do Endless Gnome

Esta pasta concentra a documentação de planejamento, arquitetura, auditoria e desenvolvimento.

## Documentos principais

- [Plano Mestre](PLANO_MESTRE.md) — direção geral e ordem de execução.
- [Roadmap](ROADMAP.md) — backlog por marcos.
- [Game Design](GAME_DESIGN.md) — visão e regras de experiência do jogo.
- [Arquitetura](ARQUITETURA.md) — organização técnica e responsabilidades.
- [Especificação de Sistemas](ESPECIFICACAO_SISTEMAS.md) — contrato esperado para cada sistema.
- [Level 01 e Fluxo](NIVEL_01_E_FLUXO.md) — desenho da primeira experiência jogável.
- [QA e Testes](QA_E_TESTES.md) — estratégia de validação.
- [Definition of Done](DEFINITION_OF_DONE.md) — critérios para encerrar tarefas.
- [Auditoria Completa](AUDITORIA_COMPLETA.md) — diagnóstico técnico do estado encontrado.
- [Mapa de Código](MAPA_DE_CODIGO.md) — relação arquivo → responsabilidade → dependências.
- [Registro de Problemas](REGISTRO_DE_PROBLEMAS.md) — backlog de problemas confirmados ou em investigação.
- [Padrão de Comentários](PADRAO_DE_COMENTARIOS.md) — padrão usado para instrumentar o código durante a auditoria.
- [Diagnóstico de Runtime](DIAGNOSTICO_RUNTIME.md) — roteiro para reproduzir as falhas em execução.

## Fluxo de trabalho

### 1. Entender

Ler a documentação do requisito antes de programar.

### 2. Auditar

Verificar código, cenas, referências, dependências e problemas conhecidos.

### 3. Planejar

Registrar a alteração no roadmap/issue e definir critérios de aceite.

### 4. Implementar

Trabalhar em branch específica, evitando misturar correção, refatoração e feature sem necessidade.

### 5. Testar

Executar smoke test, teste funcional e regressão dos sistemas afetados.

### 6. Documentar

Atualizar arquitetura, problemas, roadmap e comentários relevantes.

### 7. Revisar

Abrir Pull Request com evidências do teste e impacto da mudança.

## Fonte da verdade

O código é a fonte da verdade para o comportamento que realmente existe.

A documentação é a fonte da verdade para requisitos, decisões e estado planejado.

Quando código e documentação divergirem, a divergência deve ser registrada e resolvida deliberadamente.

## Regra desta fase de auditoria

Durante a primeira passagem, comentários e documentação devem explicar o código existente sem esconder problemas e, sempre que possível, sem alterar a lógica. Correções entram em mudanças separadas para preservar a causa original dos bugs.
