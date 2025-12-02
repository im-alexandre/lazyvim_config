# Visão geral
- Configuração do Neovim baseada em LazyVim. O `init.lua` carrega os módulos em `lua/config`, os comandos em `lua/user_commands` e define opções globais (UTF-8, formato Unix).
- O gerenciador de plugins é inicializado em `lua/config/lazy.lua`, que clona o `lazy.nvim` se necessário e registra os plugins definidos em `lua/plugins`.
- `mason-packages.txt` lista todas as ferramentas/LS que devem estar instaladas via Mason e é lido/escrito automaticamente pelo módulo `lua/plugins/mason.lua`.

# Estrutura de diretórios e arquivos
- `lazy-lock.json`, `lazyvim.json`: estados e preferências do LazyVim/lazy.nvim.
- `stylua.toml`: regras de formatação Lua.
- `mason-packages.txt`: snapshot dos pacotes Mason desejados/instalados (serve de fonte para `ensure_installed`).
- `snippets/htmldjango.json`: snippets Jinja/Django (blocks, if, for, include etc.).
- `snippets/ps1.json`: snippets de PowerShell (completers, classes, loops, funções, etc.).
- `lua/config/autocmds.lua`: autocmds extras; ajusta diffs em `[stdin]`, define filetype htmldjango para arquivos Jinja, executa `git pull` no diretório de config ao abrir o Neovim e, se houver atualização, roda `:MasonInstallFromFile`; define comando `:CiQuote`.
- `lua/config/gruvbox.lua`: aplica tema gruvbox com fundo dark.
- `lua/config/jdtls.lua`: configuração completa do LSP Java (jdtls) com debug e testes via Mason; monta caminhos do launcher/config/lombok, define `workspace_dir`, capacidades, keymaps e comandos Jdt*, e inicia/reatacha o servidor Java usando `java`.
- `lua/config/keymaps.lua`: expande keymaps do LazyVim para Telescope (definições, referências, implementações, type defs, live grep) e atalhos utilitários (`<C-w>` fecha buffer, `//` limpa highlight).
- `lua/config/lazy.lua`: bootstrap do `lazy.nvim` (clona com `git` se faltar) e opções globais de performance/checar updates.
- `lua/config/options.lua`: seleciona Telescope como picker e define `python_host` a partir do ambiente Conda (prefixo ou fallback).
- `lua/config/powershell.lua`: configura `powershell.nvim` apontando para o bundle do Mason.
- `lua/config/python_env.lua`: define `PYTHON_HOST` via variáveis Conda, registra LSP `jedi-language-server`, força formatos Unix e desativa shada; ajusta treesitter para jsonc.
- `lua/config/remove_powershell.lua`: remove o snippet PowerShell do repositório `friendly-snippets` com git (add/commit ou stash) tanto na inicialização quanto após eventos `LazyDone`.
- `lua/config/terminal.lua`: usa `pwsh.exe` como shell padrão em Windows com flags apropriadas.
- `lua/plugins/avante.lua`: configura `yetone/avante.nvim`, lê chaves de provedores (`.openai_api_key`, `.gemini_api_key` etc.) para variáveis AVANTE, define modelos e comando `:AvanteSwitch`; build via `powershell` no Windows ou `make` no restante.
- `lua/plugins/diffview.lua`: registra `sindrets/diffview.nvim` com setup simples.
- `lua/plugins/example.lua`: spec de exemplo desativado (retorna `{}` logo no início).
- `lua/plugins/flash.lua`: desabilita `folke/flash.nvim`.
- `lua/plugins/friendly-snippets.lua`: carrega snippets padrão (exceto PowerShell/ps1) e os snippets locais em `snippets/`.
- `lua/plugins/gruvbox.lua`: prioriza e configura tema gruvbox (modo transparente, contraste hard).
- `lua/plugins/mason.lua`: estende `mason.nvim`; mescla `ensure_installed` com `mason-packages.txt`, cria comandos `:MasonExport` e `:MasonInstallFromFile`, exporta lista ao instalar e ao sair do Neovim.
- `lua/plugins/mini-icons.lua`: adiciona ícones para extensões/ft Jinja (jinja, jinja2, j2, htmldjango).
- `lua/plugins/nvim-luapad.lua`: adiciona `nvim-luapad`.
- `lua/plugins/powershell.lua`: adiciona `TheLeoP/powershell.nvim`.
- `lua/plugins/snacks.lua`: configura `snacks.nvim` (dashboard) com header ASCII, atalhos e finder usando `fd`.
- `lua/plugins/telescope.lua`: ajusta `find_files` para incluir arquivos ocultos.
- `lua/plugins/toggleterm.lua`: configura `toggleterm` em janela flutuante e cria terminal dedicado para rodar `wsl /mnt/c/Users/imale/AppData/Roaming/npm/codex` via comando/tecla `Codex`.
- `lua/user_commands/init.lua`: placeholder para comandos customizados.
- `lua/user_commands/pandoc.lua`: comando `:PandocTelescope` que usa Telescope para escolher arquivo e converte via `pandoc`; suporta formatos markdown/html/docx/latex/json -> docx/pdf/html/md/pptx, usando `wkhtmltopdf` como engine PDF quando escolhido.
- `user_commands/`: diretório reservado (vazio) para comandos adicionais fora da árvore Lua.

# Dependências
- Binários de sistema usados/testados: `git` (bootstrap do lazy.nvim, autocmd de update e remoção de snippets), `java` (rodar jdtls/debug/testes), `pwsh.exe` (shell padrão no Windows), `wsl` + executável `codex` em `/mnt/c/Users/imale/AppData/Roaming/npm/codex` (terminal Codex), `fd` (finder do dashboard `snacks.nvim`), `pandoc` (checado explicitamente em `:PandocTelescope`; opcional `wkhtmltopdf` para gerar PDF), `make` (build do Avante em sistemas não-Windows).
- Dependências Python/Conda: `python` do ambiente Conda ativo (usado como `PYTHON_HOST`), módulo `jedi-language-server` acessível via `python -m`.
- Lista Mason a instalar/esperada (`mason-packages.txt`): ansible-language-server, bash-language-server, django-template-lsp, djlint, docker-compose-language-service, docker-language-server, dockerfile-language-server, google-java-format, hadolint, java-debug-adapter, java-test, jdtls, jedi-language-server, jinja-lsp, jq, json-lsp, lua-language-server, marksman, powershell-editor-services, pyright, ruff, shfmt, stylua, tree-sitter-cli.
