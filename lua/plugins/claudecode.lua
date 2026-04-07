return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		{ "<leader>a", nil, desc = "AI/Claude Code" },
		{ "<leader>at", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{
			"<leader>aF",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file (tree)",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		-- Diff management
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
	opts = {
		-- Terminal Configuration
		terminal = {
			split_side = "right",
			split_width_percentage = 0.30,
			provider = "snacks",
			auto_close = true,
			snacks_win_opts = {
				position = "bottom",
				height = 0.35,
			},

			-- Provider-specific options
			provider_opts = {
				-- Command for external terminal provider. Can be:
				-- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
				-- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
				-- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
				external_terminal_cmd = nil,
			},
		},
	},
}
