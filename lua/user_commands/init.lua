local M = {}

M.pandoc = require("user_commands.pandoc")

-- do
--   -- Caminho padrão do avante com lazy.nvim
--   local plugin_path = vim.fn.stdpath("data") .. "/lazy/avante.nvim"
--   local file_path = plugin_path .. "/lua/avante/config.lua "
--
--   if vim.fn.filereadable(file_path) == 0 then
--     return
--   end
--
--   local ok_read, lines = pcall(vim.fn.readfile, file_path)
--   if not ok_read or type(lines) ~= "table" then
--     return
--   end
--
--   local changed = false
--
--   for i, line in ipairs(lines) do
--     if line:find("Using previously selected model") then
--       -- Comentamos a linha inteira para silenciar o log
--       -- Mantém indentação mais ou menos estável
--       lines[i] = "-- PATCH(avante.nvim): log ruidoso removido: " .. line:gsub("^%s*", "")
--       changed = true
--     end
--   end
--
--   if changed then
--     pcall(vim.fn.writefile, lines, file_path)
--   end
-- end

return M
