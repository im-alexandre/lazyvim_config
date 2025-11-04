-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
opts = function()
  local Keys = require("lazyvim.plugins.lsp.keymaps").get()
  -- stylua: ignore
  vim.list_extend(Keys, {
    { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
    { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
    { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
    { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
    {"<leader>sg", function() require("telescope.builtin").live_grep({ cwd = vim.fn.getcwd(), prompt_title = "Live Grep (cwd)",}) end, desc = "Live grep (buscar string no projeto"}
  }
  )
end

local set = vim.keymap.set

set("n", "<C-w>", function()
  pcall(vim.api.nvim_buf_delete, 0, { force = false })
end, { desc = "fechar arquivo do buffer (janela) atual" })

set("n", "//", "<cmd>nohl<CR>", { desc = "tirar o highlight da busca" })

-- Atalhos
vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Abrir chat do CodeCompanion" })
vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanionChat Add<CR>", { desc = "Mandar seleção pro chat" })
