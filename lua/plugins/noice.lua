return {
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			opts.routes = opts.routes or {}

			-- mata eventos de progresso do LSP (lint/format)
			table.insert(opts.routes, {
				filter = {
					event = "lsp",
					kind = "progress",
					find = "pylsp",
				},
				opts = { skip = true },
			})

			return opts
		end,
	},
}
