return {
	"saghen/blink.cmp",
	opts_extend = { "sources.default" },
	opts = {
		completion = {
			list = {
				selection = {
					preselect = false,
				},
			},
		},
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer",
			},
			providers = {
				path = {
					opts = {
						get_cwd = function(context)
							if vim.env.NVIM_PSREADLINE_VISUAL == "1" and vim.env.PSREADLINE_VISUAL_CWD then
								return vim.env.PSREADLINE_VISUAL_CWD
							end
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
					},
				},
			},
		},
	},
}
