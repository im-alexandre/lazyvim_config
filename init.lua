-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")
require("config.gruvbox")
require("config.keymaps")
require("config.autocmds")
require("config.terminal")

if os.getenv("CONDA_PYTHON_EXE") then
  PYTHON_HOST = os.getenv("CONDA_PYTHON_EXE")
else
  PYTHON_HOST = os.getenv("CONDA_PREFIX" .. "python.exe")
end

vim.lsp.config("jedi-language-server", {
  cmd = { PYTHON_HOST, "-m", "jedi-language-server" },
})

vim.opt.fileformats = { "unix", "dos" }
vim.cmd([[
  autocmd BufWritePre * set ff=unix
]])

vim.opt.shadafile = "NONE"
require("nvim-treesitter.parsers").jsonc.revision = nil
