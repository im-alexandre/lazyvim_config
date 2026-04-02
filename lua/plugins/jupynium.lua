return {
	"kiyoon/jupynium.nvim",
	build = "pip3 install --user .",
	config = function()
		require("jupynium").setup({
			python_host = vim.g.python3_host_prog or "python",
			default_notebook_URL = "localhost:8888/nbclassic",
			jupyter_command = "jupyter",
			jupynium_file_pattern = { "*.py" },
		})

		vim.keymap.set("n", "<leader>je", function()
			vim.cmd("JupyniumExecuteSelectedCells")
			vim.fn.search("^# %%", "W")
		end, { desc = "Execute cell and jump to next" })

		vim.keymap.set("n", "<leader>ja", "ggVG<cmd>JupyniumExecuteSelectedCells<CR>", { desc = "Execute all cells" })
	end,
}
