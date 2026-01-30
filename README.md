# Configuração do Neovim com LazyVim

## Visão geral
Configuração do Neovim baseada no LazyVim. Este repositório define o comportamento do editor, plugins, ferramentas de LSP/formatadores e comandos personalizados para o desenvolvimento diário no Windows, com integração opcional com WSL.

## Stack técnica
- Linguagens: Lua (config), JSON (snippets, arquivos de lock), Markdown (docs)
- Gerenciador de plugins: lazy.nvim
- Base/distro: LazyVim
- Gerenciador de LSP/ferramentas: mason.nvim
- Plugins de UI/UX: snacks.nvim, telescope.nvim, toggleterm.nvim, diffview.nvim, gruvbox.nvim
- Assistente de IA: avante.nvim (provedor OpenAI)
- Snippets: friendly-snippets + snippets locais em `snippets/`
- Formatação: stylua (Lua), além das ferramentas do Mason listadas em `mason-packages.txt`

## Requisitos
Ferramentas e runtimes do sistema referenciados na configuração:
- Git (bootstrap do lazy.nvim, atualização automática na inicialização)
- PowerShell (pwsh.exe) no Windows
- Java (para jdtls)
- CLI `codex` (usado pelo toggleterm); pode ser sobrescrito via `CODEX_CMD` (padrão: `codex --model gpt-5.1-codex-mini`)
- curl (baixa os arquivos de spell PT-BR na primeira execução)
- fd (usado pelo buscador do dashboard do snacks.nvim)
- pandoc (para `:PandocTelescope`)
- wkhtmltopdf (opcional, usado para saída em PDF no Pandoc)

Python/Conda:
- Um ambiente Conda ativo ou instalação base com `python.exe`
- `jedi-language-server` disponível via `python -m jedi-language-server`

## Início rápido
1. Instale o Neovim e as ferramentas do sistema listadas acima.
2. Garanta que `pwsh.exe`, `git` e `java` estejam no PATH.
3. Abra o Neovim neste diretório de configuração.
4. O lazy.nvim fará o bootstrap e instalará os plugins na primeira execução.
5. Os pacotes do Mason são sincronizados a partir do `mason-packages.txt` via `:MasonInstallFromFile`.

## Estrutura do repositório
- `init.lua`: ponto de entrada; carrega módulos de configuração e integração do codex/avante.
- `lua/config/`: comportamento principal (opções, autocmds, keymaps, terminal, jdtls, env Python).
- `lua/plugins/`: specs de plugins e sobrescritas (overrides).
- `lua/user_commands/`: comandos personalizados.
- `lua/codex/`: prompt e executor (runner) do AvanteDoc.
- `snippets/`: snippets locais para Jinja/Django e PowerShell.
- `mason-packages.txt`: lista canônica de ferramentas do Mason para instalar.
- `lazy-lock.json`: versões de plugins fixadas.
- `lazyvim.json`: extras do LazyVim habilitados.

## Comandos personalizados
- `:AvanteDoc` - Gera `avante.md` na raiz do projeto usando Codex e `lua/codex/avante_project.md`.
- `:Codex` - Abre um terminal flutuante executando o comando do Codex.
- `:MasonExport` - Exporta os pacotes instalados no Mason para `mason-packages.txt`.
- `:MasonInstallFromFile` - Instala apenas as ferramentas faltantes a partir do `mason-packages.txt`.
- `:PandocTelescope` - Converte arquivos com Pandoc via um seletor do Telescope.
- `:CiQuote` - Executa um comando de alteração `ci"` e então sai do modo insert.

## Keymaps
Geral:
- `gd` - Telescope: definições do LSP
- `gr` - Telescope: referências do LSP
- `gI` - Telescope: implementações do LSP
- `gy` - Telescope: definições de tipo do LSP
- `<leader>sg` - Live grep no diretório de trabalho atual
- `<C-F4>` - Fecha o buffer atual
- `<leader>ac` - AvanteChange
- `<leader>cx` - Alterna o terminal do Codex
- `//` - Limpa o highlight de busca

Java (jdtls):
- `<leader>Jo` - Organizar imports
- `<leader>Jv` - Extrair variável (normal/visual)
- `<leader>JC` - Extrair constante (normal/visual)
- `<leader>Jt` - Rodar o teste mais próximo (normal/visual)
- `<leader>JT` - Rodar a classe de testes
- `<leader>Ju` - Atualizar configuração do projeto

## Pacotes do Mason
As ferramentas abaixo são declaradas no `mason-packages.txt` e sincronizadas automaticamente:

```
ansible-language-server
autoflake
autopep8
bash-language-server
django-template-lsp
djlint
docker-compose-language-service
docker-language-server
dockerfile-language-server
eslint-lsp
google-java-format
hadolint
java-debug-adapter
java-test
jdtls
jedi-language-server
jinja-lsp
jq
json-lsp
lua-language-server
marksman
powershell-editor-services
pyproject-fmt
pyright
ruff
shfmt
stylua
tree-sitter-cli
typescript-language-server
```

## Notas de comportamento e Autocmds
- Em `VimEnter`, um `git pull --ff-only` roda no diretório de configuração e dispara `:MasonInstallFromFile` caso atualizações tenham sido aplicadas.
- Arquivos abertos a partir de `[stdin]` são tratados como `diff` com `foldmethod=diff`.
- `*.j2`, `*.jinja`, `*.jinja2` são definidos como `htmldjango`.
- Os arquivos de spell PT-BR são baixados com `curl` caso estejam ausentes.
- `BufWritePre` força `fileformat=unix`.

## Destaques de plugins
- `avante.nvim` configurado para OpenAI com `OPENAI_API_KEY`.
- `toggleterm.nvim` fornece um terminal dedicado ao Codex.
- `snacks.nvim` dashboard com cabeçalho customizado e buscador `fd`.
- `telescope.nvim` inclui arquivos ocultos em `find_files`.
- `friendly-snippets` exclui snippets de PowerShell; snippets locais são carregados de `snippets/`.
- `mini.icons` adiciona ícones para extensões Jinja e `htmldjango`.
- `gruvbox.nvim` configurado com modo transparente e contraste hard.

## Pontos críticos e observações
- `lua/config/remove_powershell.lua` modifica o repositório do plugin `friendly-snippets` e tenta fazer commit ou stash da remoção do `PowerShell.json`.
- `lua/config/jdtls.lua` seleciona `config_win`/`config_mac`/`config_linux` conforme o sistema; ajuste se estiver rodando JDTLS em um contexto diferente do host (ex.: WSL).
- O Avante requer `OPENAI_API_KEY` no ambiente.

## Formatação e estilo
- A formatação de Lua é definida em `stylua.toml` (2 espaços, largura de coluna 120).
- Nenhum teste automatizado é definido neste repositório.
