return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false,
		-- A branch main requer avante_acp.dll, ainda ausente nos binários publicados.
		tag = "v0.4.6",
		build = vim.fn.has("win32") == 1
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		opts = {
			provider = "codex",
			acp_providers = {
				codex = {
					-- O adaptador instalado pelo npm usa um launcher .cmd no Windows.
					command = vim.fn.has("win32") == 1 and "cmd.exe" or "codex-acp",
					args = vim.fn.has("win32") == 1 and { "/d", "/c", "codex-acp.cmd" } or {},
					env = vim.tbl_extend("force", vim.fn.environ(), {
						CODEX_PATH = vim.fn.exepath("codex"),
						CODEX_CONFIG = vim.json.encode({ model = "gpt-6-luna" }),
					}),
					auth_method = "chat-gpt",
				},
			},
			selector = { provider = "snacks" },
			input = { provider = "snacks" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = { file_types = { "markdown", "Avante" } },
				ft = { "markdown", "Avante" },
			},
		},
	},
}
