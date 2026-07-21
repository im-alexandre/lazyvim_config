local function project_python(root_dir)
	local python = vim.fs.joinpath(root_dir, ".venv", "Scripts", "python.exe")
	if vim.fn.has("win32") == 0 and vim.fn.has("win64") == 0 then
		python = vim.fs.joinpath(root_dir, ".venv", "bin", "python")
	end

	if not (vim.uv or vim.loop).fs_stat(python) then
		return nil
	end

	return python
end

return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		opts = {
			servers = {
				pyright = {
					enabled = false,
				},
				ruff = {
					enabled = false,
				},
				ruff_lsp = {
					enabled = false,
				},
				basedpyright = {
					enabled = true,
					before_init = function(_, config)
						local python = project_python(config.root_dir)
						if python then
							config.settings = config.settings or {}
							config.settings.python = config.settings.python or {}
							config.settings.python.pythonPath = python
						end
					end,
					settings = {
						basedpyright = {
							disableOrganizeImports = true,
							analysis = {
								autoImportCompletions = true,
								diagnosticMode = "openFilesOnly",
								typeCheckingMode = "standard",
							},
						},
					},
				},
			},
			diagnostics = {
				virtual_text = false,
				virtual_lines = false,
				underline = false,
				update_in_insert = false,
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			},
		},
	},
	{
		"linux-cultist/venv-selector.nvim",
		opts = {
			options = {
				notify_user_on_venv_activation = true,
				override_notify = false,
				enable_cached_venvs = false,
				cached_venv_automatic_activation = false,
			},
			search = {
				cwd = {
					command = "$FD 'Scripts\\\\python.exe$' '$CWD' --full-path --color never -a -I -L -E .git -E site-packages",
				},
				workspace = {
					command = "$FD 'Scripts\\\\python.exe$' '$WORKSPACE_PATH' --full-path --color never -a -I -L -E .git -E site-packages",
				},
			},
		},
	},
}
