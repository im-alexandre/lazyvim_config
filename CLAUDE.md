# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- **Start Neovim**: `nvim`
- **Verify config boots**: `nvim --headless "+qa"`
- **Sync plugins**: `nvim --headless "+Lazy! sync" "+qa"`
- **Sync Mason tools**: `nvim --headless "+MasonInstallFromFile" "+qa"`

There is no automated test suite. Validation is done by booting Neovim and exercising the changed feature directly (e.g. `:MasonInstallFromFile`, `:Codex`, Java mappings).

## Architecture

Entry point is `init.lua`, which:
1. Bootstraps Lazy.nvim via `lua/config/lazy.lua`
2. Loads all modules under `lua/config/` and `lua/user_commands/` using a directory-scanning auto-loader (each directory has an `init.lua` that `require`s every sibling `.lua` file automatically — no manual imports needed)
3. Detects platform (`vim.g.is_android`, `vim.g.is_windows`, `vim.g.is_linux`) and conditionally loads `lua/platform/android.lua`

### Key directories

| Path | Role |
|---|---|
| `lua/config/` | Core settings: options, keymaps, autocmds, LSP-specific configs (jdtls, python_env, gruvbox, terminal) |
| `lua/plugins/` | One file per plugin or feature; each returns a LazyVim plugin spec table |
| `lua/user_commands/` | Custom `:` commands — `PandocTelescope` (file format conversion via Pandoc + Telescope picker) and `JupyniumLaunch` (start nbclassic + jupynium daemon and attach to current Neovim) |
| `lua/platform/` | Platform overrides (clipboard, performance tweaks for Android/Termux) |
| `snippets/` | Project-local snippet files (`htmldjango.json`, `ps1.json`) in VSCode JSON format |

### LazyVim extras

Enabled in `lazyvim.json`: `lang.docker`, `lang.java`, `lang.json`, `lang.markdown`, `lang.python`. These pull in treesitter parsers, LSP configs, and formatters for those languages automatically.

### Notable patterns

- **JDTLS** loads lazily on `FileType java` via autocmd in `lua/config/autocmds.lua`, not at startup.
- **Conform** chains formatters per filetype (e.g. Python: `ruff_fix` → `ruff_format`; JS/TS: `prettierd` with `prettier` fallback).
- **Python LSP** detects active Conda environments via `lua/config/python_env.lua`.
- **ClaudeCode** (`lua/plugins/claudecode.lua`) — `coder/claudecode.nvim` with Snacks terminal (bottom split, 35% height). Key bindings under `<leader>a` and `<leader>C`: toggle, focus, resume, continue, model select, add buffer, send selection, accept/deny diffs.
- **Codex** (`lua/plugins/codex.lua`) — `rhart92/codex.nvim` AI terminal, toggled via `<leader>Xt`; sends visual selection with `<leader>Xs`.
- **DAP** (`lua/plugins/dap.lua`) — `nvim-dap` + `nvim-dap-ui` (auto-opens/closes on debug events) + `nvim-dap-virtual-text` + `nvim-dap-python` (lazy on `FileType python`). `nvim-dap` has an empty `config` to prevent LazyVim's default setup from running.
- **PowerShell LSP** (`lua/plugins/powershell.lua`) — `powershell_es` connects via named pipe (not stdio): spawns the editor services process, waits for the session JSON file, then connects with `vim.lsp.rpc.connect`. Also registers a deduplicated blink.cmp source (`powershell_lsp`) for `.ps1`/`.psm1`/`.psd1` files.
- **Jupynium + Jupytext** (`lua/plugins/jupynium.lua`, `lua/plugins/jupytext.lua`) — Jupyter notebook workflow: Jupynium executes cells (`<leader>je` = execute + jump, `<leader>ja` = execute all); Jupytext syncs `.py` ↔ notebook format. Use `:JupyniumLaunch [dir]` to start nbclassic in a Snacks terminal, poll until the server is up, then spawn `python -m jupynium` without `--jupyter_command` (so it doesn't start a second server) and attach to the current Neovim via `vim.v.servername`.
- **Diffview** (`lua/plugins/diffview.lua`) — `sindrets/diffview.nvim`, loaded on `VeryLazy`.
- **PT-BR spell dictionary** auto-downloads on first boot via `ensure_pt_spell()` in `lua/config/autocmds.lua` (uses `curl` to fetch `.spl`/`.sug` from `ftp.vim.org`).
- **Jinja2 filetype** — `*.j2`/`*.jinja2`/`*.jinja` files are set to `htmldjango` via autocmd.
- `lua/config/remove_powershell.lua` patches out the PowerShell snippet file from `friendly-snippets` at startup to avoid conflicts with the local `snippets/ps1.json`.
- All modules use `pcall()` guards so missing plugins degrade gracefully.

## Coding Style

- 2-space indentation in `lua/config/`; preserve surrounding file style in `lua/plugins/`.
- Snake_case for module filenames.
- New plugin configs go in their own file under `lua/plugins/` named after the plugin/feature.
- New user commands go in their own file under `lua/user_commands/` — the auto-loader picks them up without any additional registration.

## Commit Style

Short imperative subjects, often in Portuguese (e.g. `Corrige early return em remove_potws`). Keep subjects concise and descriptive.

## External Dependencies

System tools expected to be present (see `dep_ubuntu.txt`, `dep_windows.txt`, `dep_android.txt`): `git`, `curl`, `fd`, `ripgrep`, `node`, `java`, `python3`, `pandoc`, `wkhtmltopdf`. Mason manages LSP servers and formatters declared in `lua/plugins/mason.lua`. Do not hardcode machine-specific paths — use environment variables or Neovim options.
