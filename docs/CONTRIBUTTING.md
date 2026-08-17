# GUIA DE VERSIONAMENTO: Endless Gnome

Este documento tem o intuito de orientar a equipe de desenvolvimento do projeto Endless Gnome de como como realizar o versionamento de código corretamente, seguindo os padrões de commits e branches.

Desenvolvido por: Yuji

## Padrões de Commits e Branches

### Commits

Faça commits curtos, coerentes e descritivos, seguindo a Conventional Commits.

- **feat:** nova funcionalidade
    - feat(player): adiciona sistema de inventário
    - feat: adiciona ataque do jogador
- **fix:** correções de problemas
    - fix(player): corrige colisão do jogador.
    - fix(enemy): corrige velocidade de ataque
- **test:** testes do projeto
    - test: adiciona teste de inventário
- **refactor:** reorganização ou melhora de código sem alterar comportamento
    - refactor(player): reorganiza movimentação
    - refactor(player): reorganiza o script em métodos
- **docs:** documentos de texto
    - docs: adição de manual do jogo
- **chore:** manutenção de configurações gerais
    - chore (assets): adiciona sprite do besouro
    - chore: organiza estrutura de arquivos


### Branches

- **feature:** branch de nova funcionalidade
    - feature/inventario-player
- **fix:** branch de correção
    - fix/movimentacao-player
- **hotfix:** branch de correção urgente ou durante a produção
    - hotfix/crash-fase
- **refactor:** branch de reorganização ou melhoria do código
    - refactor/inventario
- **test:** branch de teste
    - test/inventario-player
- **chore:** branch de configuração geral
    - chore/atualizacao-godot
- **release:** branch de lançamento
    - release/v1.0.0

## Estrutura Básica de Branches

```text
main
 │
 ├── feature/nome-da-funcionalidade
 │
 ├── fix/nome-do-problema
 │
 ├── refactor/nome-da-refatoracao
 │
 ├── docs/nome-do-docs
 │
 └── chore/nome-da-tarefa
```
⚠️ NÃO FAÇA COMMIT DIRETO NA MAIN ⚠️

## Fluxo de Trabalho

1. Verifique se há mudanças no repositório que precisem ser puxadas para a sua máquina local (**Fetch origin + Pull origin**). 
    - Garanta que seu projeto esteja atualizado na versão mais recente possível.

2. Evite trabalhar na mesma cena/arquivo simultaneamente: comunique-se com a equipe para evitar que duas pessoas estejam trabalhando no mesmo arquivo ao mesmo tempo.

3. Ao realizar seu commit, crie uma **nova branch** específica para a sua tarefa:
    - Terminal:

        ```text
        git checkout -b feature/nome-da-feature
        ```
    - GitHub Desktop:
        - Clique em "Current branch"
        - Verifique qual branch você está
        - Clique em "Create new branch"
    - GitHub:
        - Clique no botão "Switch branches/tags" na página Code do repositório
        - Na barra "Create or find a branch", digite o nome da sua branch
        - Clique em "Create branch [branch-nova] from [branch-antiga]"

## Pull Request

A integração com a **main** é feita com o **Pull Request**. Permite que outros membros:
- Analisem o código;
- Identifiquem possíveis problemas;
- Validem a tarefa;
- Identifiquem conflitos;
- Sugiram melhorias;
- Verifiquem se o projeto continua funcional.

Antes de solicitar a integração com a sua branch, verifique se:
- Tarefa concluída;
- Projeto abre corretamente;
- Execução sem erros relacionados às alterações;
- Não existem arquivos desnecessários
- Commits organizados;
- Commits e branches seguem o padrão estabelecido;
- A branch está atualizada em relação à main ou outra branch mais recente;
- Alterações testadas.

---