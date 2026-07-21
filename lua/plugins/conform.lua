return {
	"stevearc/conform.nvim",
	opts = {
		-- formato via <leader>ca / :Format / etc
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
		},
	},
}
