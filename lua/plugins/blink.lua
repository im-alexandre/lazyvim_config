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
				"jupynium",
			},
			providers = {
				jupynium = {
					name = "Jupynium",
					module = "jupynium.blink_cmp",
					score_offset = 100,
				},
			},
		},
	},
}
