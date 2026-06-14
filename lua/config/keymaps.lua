local set = vim.keymap.set

set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
set("n", "gr", vim.lsp.buf.references, { desc = "References" })
set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })

set({ "i", "n", "v" }, "<C-F4>", function()
	pcall(vim.api.nvim_buf_delete, 0, { force = false })
end, { desc = "fechar arquivo do buffer (janela) atual" })

set("n", "//", "<cmd>nohl<CR>", { desc = "tirar o highlight da busca" })

-- vim.keymap.set("x", "p", [["_dP]], { noremap = true, silent = true })
-- vim.keymap.set("x", "P", [["_dP]], { noremap = true, silent = true })
