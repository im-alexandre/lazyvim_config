-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config")
require("user_commands")

local uname = (vim.loop and vim.loop.os_uname and vim.loop.os_uname()) or {}
vim.g.is_android = (vim.fn.has("android") == 1) or (uname.sysname == "Linux" and vim.env.PREFIX and vim.env.PREFIX:match("com%.termux"))
vim.g.is_windows = (vim.fn.has("win32") == 1) or (vim.fn.has("win64") == 1)
vim.g.is_linux = (vim.fn.has("linux") == 1) and not vim.g.is_android

if vim.g.is_android then
  pcall(require, "platform.android")
end

