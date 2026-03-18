# Configuração do Neovim com LazyVim

Configuração pessoal do Neovim baseada no [LazyVim](https://github.com/LazyVim/LazyVim), com foco em desenvolvimento diário, integração com LSP, formatação, terminal embutido e alguns fluxos específicos para Windows, Termux/Android e Java.

Ela segue a ideia central do README original do LazyVim: um setup pronto para uso, mas fácil de expandir com módulos pequenos em `lua/config/`, `lua/plugins/` e `lua/user_commands/`.

## Destaques

- Baseada em `lazy.nvim` + LazyVim.
- LSP e ferramentas externas via Mason.
- Formatação configurada para Lua, Python, Shell, Java, JSON, Markdown e templates Django/Jinja.
- Terminal flutuante para Codex com `:Codex`.
- Integração com `jdtls` para Java.
- Dashboard, Telescope, Diffview, Noice, ToggleTerm e Gruvbox já ajustados.
- Suporte específico para Android/Termux, incluindo clipboard.

## Requisitos gerais

Além do Neovim, esta configuração depende de ferramentas externas do sistema:

- `git`
- `curl`
- `fd`
- `ripgrep`
- `python`
- `node`
- `java`
- `pandoc`
- `wkhtmltopdf` opcional para exportação em PDF

Dependências adicionais por ambiente estão nos arquivos:

- `dep_ubuntu.txt`
- `dep_windows.txt`
- `dep_android.txt`

Observações:

- No Windows, a configuração usa `pwsh` como shell padrão.
- No Android, o clipboard depende de `termux-api`.
- O comando `:Codex` depende de uma CLI disponível em `CODEX_CMD` ou do binário `codexr`.
- O Avante exige `OPENAI_API_KEY`.

## Instalação no Ubuntu

Instale o Neovim e as dependências do sistema:

```sh
sudo apt update
sudo apt install neovim $(tr '\n' ' ' < dep_ubuntu.txt)
```

Se quiser clonar esta configuração diretamente:

```sh
git clone <SEU-REPO> ~/.config/nvim
nvim
```

Na primeira execução, o `lazy.nvim` fará o bootstrap dos plugins. Depois disso, rode:

```vim
:MasonInstallFromFile
```

## Instalação no Windows

Se o Chocolatey ainda não estiver instalado, execute o comando oficial em um PowerShell com privilégios de administrador:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Depois, instale o Neovim e as dependências:

```powershell
choco install -y neovim (Get-Content .\dep_windows.txt)
```

Em seguida:

```powershell
git clone <SEU-REPO> $env:LOCALAPPDATA\nvim
nvim
```

Observações para Windows:

- `pwsh` precisa estar no `PATH`.
- Python é usado pelo `jedi-language-server`.
- Java é obrigatório para o fluxo com `jdtls`.

## Instalação no Android (Termux)

No Termux:

```sh
pkg update
pkg install neovim $(tr '\n' ' ' < dep_android.txt)
```

Se quiser clipboard funcionando, instale também o app Termux:API no Android.

Depois:

```sh
git clone <SEU-REPO> ~/.config/nvim
nvim
```

## Estrutura do repositório

```text
.
├── init.lua
├── lazyvim.json
├── lua/
│   ├── config/
│   ├── platform/
│   ├── plugins/
│   └── user_commands/
├── snippets/
├── dep_ubuntu.txt
├── dep_windows.txt
└── dep_android.txt
```

- `init.lua`: ponto de entrada.
- `lua/config/`: opções, autocmds, keymaps, terminal, JDTLS e ajustes de ambiente.
- `lua/platform/`: customizações por plataforma, como Android.
- `lua/plugins/`: specs e overrides de plugins.
- `lua/user_commands/`: comandos como `:Codex` e `:PandocTelescope`.
- `snippets/`: snippets locais.

## Comandos úteis

- `:Codex` abre o terminal flutuante do Codex.
- `:MasonInstallFromFile` instala ferramentas faltantes do Mason.
- `:MasonExport` exporta os pacotes instalados para o arquivo canônico.
- `:PandocTelescope` converte arquivos com Pandoc.
- `:Lazy sync` sincroniza plugins.

## Comportamentos importantes

- Ao iniciar, a configuração pode executar `git pull --ff-only` no diretório do Neovim.
- Se faltarem arquivos de spell em PT-BR, eles são baixados com `curl`.
- Arquivos `*.j2`, `*.jinja` e `*.jinja2` são tratados como `htmldjango`.
- Arquivos Java carregam o `jdtls` sob demanda.
- `BufWritePre` força `fileformat=unix`.

## Ferramentas gerenciadas pelo Mason

LSPs, linters e formatadores como `lua-language-server`, `pyright`, `ruff`, `stylua`, `shfmt`, `djlint`, `jq`, `jdtls` e `powershell-editor-services` são instalados via Mason, não pelo sistema operacional diretamente.

## Desenvolvimento e manutenção

Para validar a configuração sem interface:

```sh
nvim --headless "+qa"
```

Para sincronizar plugins:

```sh
nvim --headless "+Lazy! sync" "+qa"
```

Para instalar ferramentas do Mason após um bootstrap novo:

```sh
nvim --headless "+MasonInstallFromFile" "+qa"
```

## Notas finais

Esta configuração assume que você quer um Neovim opinativo, já pronto para edição de código, terminal, busca, Java, Python, templates Django/Jinja e uso diário em mais de um ambiente. Se algo falhar no primeiro boot, o ponto inicial de inspeção costuma ser: `:checkhealth`, `:Lazy`, `:Mason` e o `PATH` do sistema.
