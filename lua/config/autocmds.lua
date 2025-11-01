-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Auto update da config do LazyVim
-- AUTOCMD: Git pull no config; se atualizou, roda :MasonInstallFromFile
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
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local config_path = vim.fn.stdpath("config")
    local out, err = {}, {}
    local cmd = { "git", "-C", config_path, "pull", "--ff-only" }
    vim.fn.jobstart(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_stdout = function(_, data)
        if data and #data > 0 then
          for _, l in ipairs(data) do
            if l ~= "" then
              table.insert(out, l)
            end
          end
          vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "LazyVim Git Pull" })
        end
      end,
      on_stderr = function(_, data)
        if data and #data > 0 then
          vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, { title = "LazyVim Git Pull" })
        end
      end,
      on_exit = function(_, code)
        local stdout = table.concat(out, "\n")
        local updated = (code == 0)
          and not stdout:match("[Aa]lready up%-to%-date")
          and not stdout:match("[Aa]lready up to date")
        if stdout:match("[Ff]ast%-forward") or stdout:match("[Uu]pdating%s+[%w]+%.+[%w]+") then
          updated = true
        end
        if updated then
          vim.schedule(function()
            vim.cmd("MasonInstallFromFile") -- agora só instala o que falta
          end)
        end
      end,
    })
  end,
})
