return {
	-- LSP servers
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"basedpyright",
				"codebook",
				"docker_compose_language_service",
				"dockerls",
				"jdtls",
				"lua_ls",
				"marksman",
				"powershell_es",
				"taplo",
				"vtsls",
				"yamlls",
				"ansiblels",
			},
		},
	},

	-- Non-LSP tools (formatters/linters/etc)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"dockerfmt",
				"hadolint",
				"jupytext",
				"markdown-toc",
				"markdownlint-cli2",
				"prettier",
				"pyproject-fmt",
				"ruff",
				"shfmt",
				"stylua",
			},
			run_on_start = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- The Dockerfile and Compose servers above already cover these files.
				docker_language_server = { enabled = false },
			},
		},
	},
}
