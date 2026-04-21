return {
	"yetone/avante.nvim",
	opts = {
		provider = "codex",
		debug = false,
		system_prompt = [[
Seja direto e curto.
Priorize implementar antes de explicar.
Não narre plano, fallback, sandbox ou passos internos.
Ao editar arquivos, responda com:
- o que foi alterado
- o arquivo alterado
No máximo 3 linhas.
Quando eu pedir código, entregue o código completo atualizado.
Evite refatoração desnecessária.
Preserve estilo existente do projeto.
Antes de mudar muitos arquivos, prefira a menor alteração correta.
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
					'model="gpt-5.4"',
					"-c",
					'reasoning_effort="medium"',
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
