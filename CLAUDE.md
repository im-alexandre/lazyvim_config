# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal Neovim configuration built on [LazyVim](https://github.com/LazyVim/LazyVim). The primary language is Portuguese (BR) for comments and UI strings. Runs on Windows (primary), Ubuntu, and Android/Termux.

## Key Commands

```sh
# Validate config loads without errors
nvim --headless "+qa"

# Sync all plugins
nvim --headless "+Lazy! sync" "+qa"

# Install Mason tools after fresh bootstrap
nvim --headless "+MasonInstallFromFile" "+qa"
```

Inside Neovim: `:Lazy sync`, `:MasonInstallFromFile`, `:MasonExport`, `:Codex`, `:PandocTelescope`.

## Architecture

**Entry point**: `init.lua` loads three modules in order: `config.lazy` (bootstraps lazy.nvim + LazyVim), `config` (all config modules), `user_commands` (custom commands). It then sets platform flags (`vim.g.is_android`, `vim.g.is_windows`, `vim.g.is_linux`).

**Auto-loading via scandir**: Both `lua/config/init.lua` and `lua/user_commands/init.lua` use the same pattern — they scan their own directory and `require()` every `.lua` file except `init.lua` itself. Adding a new file to either directory is enough to activate it. Exception: `config.jdtls` is excluded from auto-load and loaded on-demand via a `FileType java` autocmd.

**Plugin specs** live in `lua/plugins/`. Each file returns a lazy.nvim spec table. LazyVim extras for Docker, Java, JSON, Markdown, and Python are enabled in `lazyvim.json`.

**Platform layer**: `lua/platform/android.lua` is loaded conditionally at startup for Termux-specific adjustments (clipboard, etc.).

**Formatter pipeline** (conform.nvim): Python uses `ruff_fix` then `ruff_format`. Lua uses `stylua`. Shell uses `shfmt`. Web/JSON/Markdown use `prettierd`/`prettier`. Django/Jinja templates use `djlint`. Java uses `google-java-format`.

**Python LSP**: The LazyVim Python extra provides **pyright** (type checking, auto-import, code actions) + **ruff LSP** (linting diagnostics, quick fixes). `lua/config/python_env.lua` resolves the Python host from Conda environment variables (falls back to `D:/tools/anaconda3/python.exe`) and sets `pyright`'s `pythonPath` on first Python file open. Ruff diagnostics come from the LSP only (not nvim-lint) to avoid duplication.

**File format enforcement**: `BufWritePre *` forces `fileformat=unix` on every save.

## Conventions

- All files use `fileformat=unix` (LF), enforced by autocmd.
- Spell checking is always on, with `spelllang = { "en", "pt" }`. PT-BR spell files are auto-downloaded on first run if missing.
- Picker is Telescope (`vim.g.lazyvim_picker = "telescope"`), not fzf-lua.
- LSPs, formatters, and linters are managed exclusively through Mason — do not install them via system package managers.
- The `vendor/` directory contains local plugin forks (e.g., `codex.nvim`); it is not committed (listed in gitignore).

## Notebook Workflow (Jupynium)

- `*.ju.py` files are the single source of truth for notebooks.
- Opening a `*.ju.py` auto-starts `nbclassic` and Jupynium sync.
- `jupytext.nvim` is intentionally disabled to prevent `ipynb <-> py` pairing.
- Regular `*.py` and `*.md` files must stay outside Jupynium sync.
- nbclassic autosave must be disabled via `~/.jupyter/custom/custom.js` to avoid reload prompts.
