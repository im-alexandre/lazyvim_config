return {
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			opts.routes = opts.routes or {}
			return opts
		end,
	},
}
