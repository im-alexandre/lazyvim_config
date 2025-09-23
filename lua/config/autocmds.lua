-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Auto update da config do LazyVim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- caminho do diretório de configuração
    local config_path = vim.fn.stdpath("config")
    local cmd = { "git", "-C", config_path, "pull", "--ff-only" }
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        if data and #data > 0 then
          vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "LazyVim Git Pull" })
        end
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, { title = "LazyVim Git Pull" })
        end
      end,
    })
  end,
})
