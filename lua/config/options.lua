-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.linespace = 8

vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix" }
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Ativa o spellcheck globalmente (opcional, se quiser sempre ligado)
vim.opt.spell = true

-- Define as linguagens: Inglês E Português
vim.opt.spelllang = { "en", "pt" }
vim.g.lazyvim_picker = "telescope"

vim.opt.shadafile = "NONE"
