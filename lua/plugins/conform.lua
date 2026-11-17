return {
	"stevearc/conform.nvim",
	opts = {
		-- formato via <leader>ca / :Format / etc
		formatters_by_ft = {
			dockerfile = { "dockerfmt" },
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			toml = function(bufnr)
				return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t") == "pyproject.toml"
						and { "pyproject-fmt" }
					or { "taplo" }
			end,
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
		},
	},
}
