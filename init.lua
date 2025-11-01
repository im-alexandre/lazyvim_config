-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.autocmds")
require("config.gruvbox")
require("config.keymaps")
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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.j2", "*.jinja2", "*.jinja" },
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})
