# AGENTS.md

## Repository shape

- This is a personal LazyVim-based Neovim configuration.
- `init.lua` bootstraps `config.lazy`, then loads `config` and `user_commands`.
- `lua/config/init.lua` auto-requires sibling config modules except `jdtls`; keep `lua/config/jdtls.lua` lazy because Java startup loads it on `FileType java`.
- `lua/user_commands/init.lua` auto-requires sibling command modules; currently this is for commands such as `PandocTelescope`.
- Add or change plugin specs in `lua/plugins/`, one integration per file when practical.
- Local VS Code-style snippets live in `snippets/`.
- GitHub Claude automation lives in `.github/workflows/`.
- `CLAUDE.md` was removed from tracked history; a local untracked copy may exist, but treat this file as the durable tracked guidance.
- `vendor/codex.nvim/` may exist as an untracked local plugin fork and has its own `AGENTS.md`; do not treat it as part of the tracked Neovim config unless the task explicitly targets it.

## Recent commit context

- `a016d12` on 2026-04-06 rewrote the notebook/Codex area: deleted `CLAUDE.md`, deleted `lua/plugins/jupytext.lua`, deleted `lua/user_commands/jupynium.lua`, added `requirements.txt`, added `lua/plugins/blink.lua`, expanded `lua/plugins/codex.lua`, and rewrote `lua/plugins/jupynium.lua`.
- `4b3d926` on 2026-04-04 added this `AGENTS.md` and set `vim.opt.shadafile = "NONE"` in `lua/config/options.lua`.
- `2502be7` on 2026-04-02 introduced `claudecode.nvim`, `codex.nvim`, and the first Jupynium/Jupytext setup, while deleting the older ToggleTerm-backed `lua/user_commands/codex.lua`.
- The Claude GitHub Actions workflows were added on 2026-03-29 and are still present under `.github/workflows/`.

## Notebook workflow

- Treat `*.ju.py` as the only editable notebook source of truth.
- Keep regular `*.py` files and `*.md` files outside Jupynium sync.
- Do not re-enable `jupytext.nvim` unless the goal is explicitly to restore `ipynb <-> py` pairing.
- The current code in `lua/plugins/jupynium.lua` scopes Jupynium to `jupynium_file_pattern = { "*.ju.py" }`.
- The current code sets Jupynium built-in `auto_start_server`, `auto_attach_to_server`, and `auto_start_sync` to `enable = false`.
- The current launcher is the local `start_services()` function bound to `<leader>js`, which starts `nbclassic` and then `jupynium` with `C:/tools/miniforge3/pythonw.exe`.
- Do not resurrect the deleted `:JupyniumLaunch` command from `lua/user_commands/jupynium.lua` unless the task explicitly asks for that workflow.
- If a task asks for automatic open/attach/sync when opening `*.ju.py`, update `lua/plugins/jupynium.lua` directly and validate the behavior; the README may describe this desired behavior more strongly than the current code implements it.

## nbclassic autosave

The classic notebook frontend must have autosave disabled to avoid reload prompts while Neovim edits the source file.

Required file:

- `C:\Users\imale\.jupyter\custom\custom.js`

Required behavior:

- call `Jupyter.notebook.set_autosave_interval(0);` on notebook load;
- keep this scoped to `nbclassic`, not JupyterLab.

If notebook reload prompts come back, inspect `custom.js` before changing the Neovim plugin config.

## AI integrations

- Codex uses `rhart92/codex.nvim` in `lua/plugins/codex.lua`; do not restore the old ToggleTerm `:Codex` command unless explicitly requested.
- Codex keymaps are under `<leader>X`: `<leader>Xt` toggles, visual `<leader>Xs` sends a selection without submitting, and `<leader>Xb` sends the current buffer reference.
- Codex selection payloads include the file basename and selected line range; buffer payloads tell Codex to read the file from disk.
- `vim.o.autoread = true` is set by the Codex plugin spec so external edits can be picked up.
- Claude Code uses `coder/claudecode.nvim` in `lua/plugins/claudecode.lua` with a Snacks terminal at the bottom, height `0.35`.
- Claude Code keymaps are under `<leader>a`: toggle, focus, resume, continue, model select, add buffer, send selection, and accept/deny diffs.

## Completion, snippets, and PowerShell

- `blink.cmp` is the completion backend. `lua/plugins/blink.lua` adds the Jupynium source to the default sources.
- `lua/plugins/powershell.lua` adds a dedicated `powershell_lsp` blink provider for `ps1`, `psm1`, and `psd1` to sanitize and deduplicate PowerShell LSP completions.
- `lua/plugins/friendly-snippets.lua` excludes upstream PowerShell snippets and loads local snippets from `snippets/`.
- `lua/config/remove_powershell.lua` still mutates the installed `friendly-snippets` checkout to remove `snippets/PowerShell.json`; be careful when changing this because it can create local commits or stashes inside the plugin checkout.

## Python, Mason, and formatting

- `requirements.txt` documents the validated Python notebook environment, including Jupynium, Jupyter, nbclassic, nbconvert, notebook, pywin32, and related packages.
- `lua/plugins/jupynium.lua` currently hardcodes `C:/tools/miniforge3/python.exe` and `C:/tools/miniforge3/pythonw.exe`; preserve that unless the task is to make the setup portable.
- `lua/config/python_env.lua` resolves the Python host from Conda env vars (falls back to `D:/tools/anaconda3/python.exe`) and configures `pyright`'s `pythonPath` on first Python file open. The LazyVim Python extra provides pyright (type checking, auto-import, code actions) + ruff LSP (linting, quick fixes). jedi-language-server was removed — do not re-add it.
- Python linting comes exclusively from the ruff LSP; `lua/plugins/lint.lua` does not list ruff for Python to avoid duplicate diagnostics.
- Mason-managed LSPs and tools are declared in `lua/plugins/mason.lua`.
- Conform formatting is declared in `lua/plugins/conform.lua`; Python uses `ruff_fix` then `ruff_format`, and template formats use `djlint`.
- `lua/config/options.lua` forces UTF-8, Unix file format defaults, global spellcheck for English and Portuguese, Telescope as LazyVim picker, global statusline, and `shadafile = "NONE"`.
- `lua/config/python_env.lua` also restores `fileformats = { "unix", "dos" }` and adds a `BufWritePre` autocmd that writes files as Unix line endings.

## Validation

- For general config edits, run `nvim --headless "+qa"` when feasible.
- For plugin dependency changes, use `nvim --headless "+Lazy! sync" "+qa"` only when plugin sync is actually needed.
- For Mason changes, validate with `nvim --headless "+MasonInstallFromFile" "+qa"` when relevant.
- For notebook changes, validate interactively with a `*.ju.py` file because headless startup cannot prove browser attach/sync behavior.
- For AI terminal changes, validate the keymap or command path you touched, especially focus behavior after sending a selection.
- Document any validation gap if an interactive or platform-specific check cannot be run.
