local M = {}

local function scandir(directory)
  local dir = vim.loop.fs_scandir(directory)
  return function()
    return dir and vim.loop.fs_scandir_next(dir)
  end
end

for file in scandir(debug.getinfo(1).source:match("@?(.*/)")) do
  if file:match("%.lua$") and file ~= "init.lua" then
    local moduleName = file:match("(.+)%.lua$")
    M[moduleName] = require("config." .. moduleName)
  end
end

return M
