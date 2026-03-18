# Repository Guidelines

## Project Structure & Module Organization
This repository is a Neovim configuration built on LazyVim. `init.lua` is the entry point and loads the core modules under `lua/config/`, plugin specs under `lua/plugins/`, and custom commands under `lua/user_commands/`. Local snippets live in `snippets/`, and `lazyvim.json` declares enabled LazyVim extras. Keep new behavior in the closest matching module instead of expanding `init.lua`.

## Build and Development Commands
Use Neovim itself as the main execution environment:

- `nvim` starts the config locally.
- `nvim --headless "+qa"` verifies the config boots without UI errors.
- `nvim --headless "+Lazy! sync" "+qa"` installs or updates plugins.
- `nvim --headless "+MasonInstallFromFile" "+qa"` syncs external tools declared by the config.
- `nvim --headless "+lua require('conform').format({ async = false })" "+qa"` is a quick way to confirm formatter wiring.

## Coding Style & Naming Conventions
Lua is the primary language. Follow the existing style in `lua/`: 2-space indentation is common in core config files, while some plugin specs keep existing tab-based indentation; preserve the surrounding file’s style instead of reformatting unrelated lines. Use lowercase snake_case for module filenames such as `python_env.lua` and `remove_powershell.lua`. Prefer small, focused plugin spec files named after the plugin or feature they configure.

## Verification Guidelines
This repository does not require an automated test suite. The expected verification is simple: confirm that Neovim starts, plugins sync, and the edited workflow behaves correctly inside the editor. For LSP, formatter, or command changes, validate the relevant action directly, for example `:MasonInstallFromFile`, `:Codex`, or the Java mappings from `lua/config/jdtls.lua`.

## Commit & Pull Request Guidelines
Recent history uses short, imperative commit subjects, often in Portuguese, for example `Corrige early return em remove_potws` and `Suporte a android`. Keep subjects concise and descriptive; avoid placeholder messages like `-`. Pull requests should explain the user-facing change, list any required external tools or environment variables, and include screenshots only when UI elements such as dashboards, colorschemes, or floating terminals change.

## Configuration Notes
This config expects external tools such as `git`, `java`, `pwsh`, `stylua`, and Mason-managed binaries. Do not hardcode machine-specific paths when an environment variable or Neovim option can be used instead.
