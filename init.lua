-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.gruvbox")
require("config.keymaps")
require("config.autocmds")
require("config.terminal")
require("config.remove_powershell")
require("config.python_env")
require("config.powershell")
require("config.jdtls")

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "[stdin]" },
  callback = function()
    vim.bo.filetype = "diff"
    vim.opt.foldmethod = "diff"
  end,
})
