return {
	{
		"vim-pandoc/vim-pandoc-syntax",
		ft = { "markdown", "pandoc" },

		init = function()
			vim.g["pandoc#syntax#conceal#use"] = true
			vim.g["pandoc#syntax#conceal#urls"] = true

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(event)
					vim.treesitter.stop(event.buf)
					vim.bo[event.buf].syntax = "markdown.pandoc"
					vim.opt_local.conceallevel = 2
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
				end,
			})
		end,
	},
}
