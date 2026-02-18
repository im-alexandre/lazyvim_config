-- lua/platform/android.lua

-- Clipboard via Termux (sem X11)
vim.g.clipboard = {
  name = "termux",
  copy = {
    ["+"] = "termux-clipboard-set",
    ["*"] = "termux-clipboard-set",
  },
  paste = {
    ["+"] = "termux-clipboard-get",
    ["*"] = "termux-clipboard-get",
  },
  cache_enabled = false,
}

-- Reduz custo em terminal mobile
vim.opt.updatetime = 300
vim.opt.timeoutlen = 400
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 200
