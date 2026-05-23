# Repository Guidelines

## Project Structure & Module Organization

This repository is a Neovim configuration based on LazyVim. `init.lua` is the entry point and loads `lua/config`, `lua/plugins`, and `lua/user_commands`.

- `lua/config/`: core editor configuration, options, keymaps, autocommands, terminal setup, and language-specific setup such as `jdtls.lua`.
- `lua/plugins/`: Lazy plugin specs and overrides. Add one focused file per plugin or feature, for example `telescope.lua` or `conform.lua`.
- `lua/user_commands/`: custom commands grouped by feature.
- `lua/platform/`: platform-specific behavior, currently Android support.
- `snippets/`: VS Code-style JSON snippets by filetype.
- `dep_*.txt`, `requirements.txt`: external dependencies for different environments.

## Build, Test, and Development Commands

- `nvim --headless "+Lazy! sync" +qa`: install and sync Lazy plugins.
- `nvim --headless "+Lazy! check" +qa`: check plugin updates without opening the UI.
- `nvim --headless "+checkhealth" +qa`: run Neovim health checks.
- `nvim --headless "+luafile init.lua" +qa`: smoke-test that the configuration loads.
- `nvim`: run the configuration interactively.

There is no separate build step; changes are loaded by Neovim at startup or by re-sourcing Lua files.

## Coding Style & Naming Conventions

Write Lua modules as small, focused files that return plugin specs or configure one concern. Use lowercase snake_case filenames, matching the existing pattern such as `remove_powershell.lua` and `python_env.lua`.

Use Lua comments for intent, not narration. Keep existing indentation style within a file: many plugin files use tabs, while core config files may use two spaces. Format Lua with `stylua` when available. JSON snippets should remain valid, compact, and scoped to their target filetype.

## Testing Guidelines

No formal test suite is configured. Validate changes with headless Neovim commands and an interactive startup check. For plugin changes, run `:Lazy sync`, open Neovim, and confirm the affected keymaps, commands, or filetypes work. For formatter or linter changes, test with a representative file and confirm `conform.nvim` or lint integration resolves the expected tool.

## Commit & Pull Request Guidelines

Recent git history does not show descriptive commit conventions, so use clear imperative messages such as `Add PowerShell terminal config` or `Fix Lua formatter setup`.

Pull requests should include a short description, the affected modules, validation commands run, and screenshots only for visible UI changes. Link related issues when available and mention platform-specific impact for Windows, Linux, or Android changes.

## Agent-Specific Instructions

Preserve user-local behavior. Do not rewrite unrelated plugin specs or lockfiles unless the task requires it. When editing dependencies, keep `lazy-lock.json` consistent with the plugin changes and avoid removing platform files that are not part of the request.
