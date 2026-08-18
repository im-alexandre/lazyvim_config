return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = {
				"markdown",
				"markdown_inline",
				"toml",
				"lua",
				"python",
				"json",
				"yaml",
				"bash",
			}
		end,
	},
}
