return {
	{
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		opts = {
			diff = {
				layout = "side-by-side",
				compact = true,
				compute_moves = true,
			},
			explorer = {
				view_mode = "tree",
				line_stats = {
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<leader>gd",
				"<cmd>CodeDiff<cr>",
				desc = "Git diff",
			},
			{
				"<leader>gD",
				"<cmd>CodeDiff origin/main...HEAD<cr>",
				desc = "Diff da branch",
			},
		},
	},
}
