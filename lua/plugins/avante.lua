return {
	"yetone/avante.nvim",
	opts = {
		provider = "codex",
		debug = false,
		system_prompt = [[
      "Seja direto e curto.",
      "Não descreva plano antes de agir.",
      "Não narre tentativas, fallback, sandbox ou passos internos.",
      "Ao editar arquivos, responda só com:",
      "- o que foi alterado",
      "- o arquivo alterado",
      "No máximo 3 linhas.",
    ]],
		behaviour = {
			auto_suggestions = false,
			enable_token_counting = false,
		},
		acp_providers = {
			codex = {
				command = "C:\\Users\\imale\\AppData\\Roaming\\npm\\codex-acp.cmd",
				args = {
					"-c",
					'model="gpt-5.3-codex-spark"',
					"-c",
					'sandbox_mode="danger-full-access"',
					"-c",
					'approval_policy="never"',
					"-c",
					'windows.sandbox="elevated"',
				},
				env = {
					NODE_NO_WARNINGS = "1",
				},
			},
		},
	},
}
