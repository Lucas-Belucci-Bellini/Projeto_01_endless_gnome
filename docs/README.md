# Documentação do Endless Gnome

Esta pasta concentra a documentação de planejamento e desenvolvimento.

## Documentos principais

- [Plano Mestre](PLANO_MESTRE.md) — direção geral e ordem de execução.
- [Roadmap](ROADMAP.md) — backlog por marcos.
- [Game Design](GAME_DESIGN.md) — visão e regras de experiência do jogo.
- [Arquitetura](ARQUITETURA.md) — organização técnica e responsabilidades.
- [Especificação de Sistemas](ESPECIFICACAO_SISTEMAS.md) — contrato esperado para cada sistema.
- [Level 01 e Fluxo](NIVEL_01_E_FLUXO.md) — desenho da primeira experiência jogável.
- [QA e Testes](QA_E_TESTES.md) — estratégia de validação.
- [Definition of Done](DEFINITION_OF_DONE.md) — critérios para encerrar tarefas.

## Como usar esta documentação

### Antes de programar

Leia o Plano Mestre, o Roadmap e a especificação do sistema que será alterado.

### Durante a programação

Mantenha a implementação dentro das responsabilidades descritas na Arquitetura.

### Antes do Pull Request

Use o QA e a Definition of Done para validar a mudança.

### Depois da integração

Atualize o Roadmap e registre decisões relevantes.

## Fonte da verdade

O código é a fonte da verdade para o comportamento existente.

A documentação é a fonte da verdade para requisitos, decisões e estado planejado.

Quando código e documentação divergirem, a divergência deve ser registrada e resolvida deliberadamente; não deve ser escondida.
