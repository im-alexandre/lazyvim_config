-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.autocmds")
require("config.gruvbox")
require("config.keymaps")
require("config.remove_powershell")
require("config.python_env")
require("config.powershell")
require("config.jdtls")
require("config.terminal")
require("user_commands")

vim.opt.fileencoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix" }
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
