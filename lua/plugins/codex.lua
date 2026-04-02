return {
	"rhart92/codex.nvim",
	lazy = false,
	init = function()
		vim.o.autoread = true
	end,
	keys = {
		{
			"<leader>X",
			nil,
			desc = "Codex",
		},
		{
			"<leader>Xt",
			function()
				require("codex").toggle()
			end,
			desc = "Codex: toggle",
		},
		{
			"<leader>Xs",
			function()
				require("codex").actions.send_selection()
				vim.schedule(function()
					vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "x", false)
					require("codex.ui").focus()
					vim.cmd("startinsert")
				end)
			end,
			mode = "v",
			desc = "Codex: send selection",
		},
	},
}
