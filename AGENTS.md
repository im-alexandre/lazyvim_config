# AGENTS.md

## Notebook workflow

- Use `*.ju.py` as the only editable notebook source of truth.
- Opening a `*.ju.py` should auto-start `nbclassic`, auto-attach Jupynium, and auto-start sync.
- Do not re-enable `jupytext.nvim` for this workflow unless you explicitly want `ipynb <-> py` pairing again.
- Regular `*.py` files and `*.md` files must stay outside Jupynium sync.

## nbclassic autosave

The classic notebook frontend must have autosave disabled to avoid reload prompts while Neovim edits the source file.

Required file:

- `C:\Users\imale\.jupyter\custom\custom.js`

Required behavior:

- call `Jupyter.notebook.set_autosave_interval(0);` on notebook load;
- keep this scoped to `nbclassic`, not JupyterLab.

If notebook reload prompts come back, inspect `custom.js` first before changing the Neovim plugin config.
