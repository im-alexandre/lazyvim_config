# Repository Guidelines

## Project Structure & Module Organization
This repository is a Neovim configuration built around LazyVim. The entry point is `init.lua`, which bootstraps Lazy and auto-loads modules from sibling directories.

- `lua/config/`: core editor behavior such as options, keymaps, autocmds, and LSP helpers.
- `lua/plugins/`: one plugin spec per file; add new integrations here.
- `lua/user_commands/`: custom `:` commands, auto-loaded without manual registration.
- `lua/platform/`: platform-specific overrides, including Android behavior.
- `snippets/`: project-local VS Code style snippet JSON files.
- `.github/workflows/`: GitHub automation for Claude-related workflows.

There is no conventional test suite; validation is done by booting Neovim and exercising the changed feature directly.

## Build, Test, and Development Commands
- `nvim`: start Neovim with this configuration.
- `nvim --headless "+qa"`: verify the config boots without startup errors.
- `nvim --headless "+Lazy! sync" "+qa"`: sync/update plugins.
- `nvim --headless "+MasonInstallFromFile" "+qa"`: install Mason-managed tools declared by the config.

For feature work, validate the exact workflow you changed. Examples: run `:MasonInstallFromFile`, open `:Codex`, or test Java file startup for JDTLS.

## Coding Style & Naming Conventions
Use Lua conventions already present in the repo.

- Prefer 2-space indentation in `lua/config/`; preserve the surrounding style elsewhere.
- Use `snake_case` for Lua module filenames.
- Put each new plugin config in its own file under `lua/plugins/`.
- Put each new user command in its own file under `lua/user_commands/`.
- Keep defensive `pcall()` guards where the surrounding code uses them so missing plugins degrade cleanly.

Do not hardcode machine-specific paths; prefer environment variables or Neovim options.

## Testing Guidelines
Testing is manual and behavior-focused.

- Always run `nvim --headless "+qa"` after config changes.
- Reproduce the user-facing workflow you touched.
- If a change is platform-specific, verify it on the relevant platform path under `lua/platform/`.

Document any validation gaps in the PR when you cannot test interactively.

## Commit & Pull Request Guidelines
Commit subjects should be short, imperative, and descriptive. Portuguese subjects are common, for example: `Corrige early return em remove_potws`.

Pull requests should include:

- a brief description of the change and affected area
- manual validation steps performed
- screenshots or terminal snippets when UI behavior changes
- linked issues or context when applicable
