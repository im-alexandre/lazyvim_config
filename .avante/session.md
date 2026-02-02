# VISÃO GERAL
- Configuração do Neovim baseada em LazyVim (perfil pessoal).
- Serve para produtividade diária: LSP, snippets, tema, terminal, IA (Avante).
- Resultado esperado: inicialização estável, plugins consistentes e fluxo de edição rápido.

# STACK E TECNOLOGIAS
- Linguagem: Lua (Neovim config).
- Frameworks/libs: LazyVim, lazy.nvim, nvim-lspconfig, mason.nvim, telescope.nvim, snippets (friendly-snippets + locais).
- Integrações externas: Mason packages, jdtls (Java), powershell.nvim, pandoc, wkhtmltopdf, fd, wsl/codex.
- LLM/API: Avante.nvim com providers (OpenAI/Anthropic/Abacus) via env vars.

# ESTRUTURA DO REPOSITÓRIO
- `init.lua`: ponto de entrada, carrega `lua/config` e `lua/user_commands`.
- `lua/config/*`: opções, autocmds, keymaps, tema, shell, jdtls, python env.
- `lua/plugins/*`: specs do lazy.nvim (core e integrações).
- `snippets/*`: snippets locais (ex.: ps1, htmldjango).
- `mason-packages.txt`: lista de ferramentas para Mason (fonte de `ensure_installed`).
- Core: `lua/config`, `lua/plugins`, `init.lua`.
- Utilitário: `snippets`, `mason-packages.txt`, `README.md`.

# FLUXOS CRÍTICOS
- Execução: `init.lua` -> `config.lazy` -> plugins -> `config` -> autocmds.
- LLM: `avante.nvim` (modo legacy, sem tools) usa env vars de chaves e aplica diffs com mapeamento.
- Integrações: Mason instala tools; LSPs sobem por filetype; jdtls só em projeto Java.

# CONVENÇÕES E PADRÕES
- Configs em Lua com arquivos pequenos por tema.
- Plugins configurados via `lua/plugins/*.lua` com `opts`/`config`.
- Mudanças: preferir overrides locais em `lua/plugins` e `lua/config`.
- `mason-packages.txt` é a fonte para instalação; evitar divergência manual.

# GUARDRAILS (O QUE NÃO FAZER)
- Evitar refatorações amplas sem pedir.
- Não mudar APIs públicas ou comportamento base do LazyVim sem alinhamento.
- Não criar módulos novos sem necessidade real.
- Não reimprimir arquivos completos por padrão; preferir trechos/diffs.

# COMO RESPONDER NO AVANTE
- Preferir diffs ou trechos mínimos.
- Ser direto e técnico.
- Pedir contexto adicional só quando indispensável.
- Não usar modo agentic nem ferramentas.

# CONTEXTO ATUAL
- Startup otimizado: removido `git pull` automático; jdtls e PYTHON_HOST só em filetypes.
- Avante em modo legacy, tools desativadas; mapeamento `a` aplica trecho.
- Snippets PowerShell do friendly-snippets desativados; locais carregados.
- Ponto sensível: jdtls ainda pode falhar por ambiente/launcher/config.
