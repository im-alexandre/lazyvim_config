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
| `lua/user_commands/` | Custom `:` commands — currently `Codex` (AI terminal) and `PandocTelescope` (file format conversion) |
| `lua/platform/` | Platform overrides (clipboard, performance tweaks for Android/Termux) |
| `snippets/` | Project-local snippet files (`htmldjango.json`, `ps1.json`) in VSCode JSON format |

### LazyVim extras

Enabled in `lazyvim.json`: `lang.docker`, `lang.java`, `lang.json`, `lang.markdown`, `lang.python`. These pull in treesitter parsers, LSP configs, and formatters for those languages automatically.

### Notable patterns

- **JDTLS** loads lazily on `FileType java` via autocmd in `lua/config/autocmds.lua`, not at startup.
- **Conform** chains formatters per filetype (e.g. Python: `ruff_fix` → `ruff_format`; JS/TS: `prettierd` with `prettier` fallback).
- **Python LSP** detects active Conda environments via `lua/config/python_env.lua`.
- **Avante** (AI assistant) is configured with diff preview before applying changes; provider switches to Claude automatically on its ready event.
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
