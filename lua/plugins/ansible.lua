local function detect_playbook(_, bufnr)
	if bufnr == -1 then
		return
	end

	local play_indent
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)
	for _, line in ipairs(lines) do
		local document_start = line:match("^%-%-%-%s*$") or line:match("^%-%-%-%s+#")
		if not document_start and not line:match("^%s*$") and not line:match("^%s*#") then
			local dash, field = line:match("^(%s*%-%s+)(.*)$")
			if dash and (not play_indent or #dash <= play_indent) then
				play_indent = #dash
			elseif not play_indent then
				return
			else
				local indent
				indent, field = line:match("^(%s*)(.*)$")
				if #indent ~= play_indent then
					field = ""
				end
			end
			if field:match("^hosts:") or field:match("^import_playbook:") then
				return "yaml.ansible"
			end
		end
	end
end

local is_windows = vim.fn.has("win32") == 1

return {
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			if is_windows then
				opts.ensure_installed = vim.tbl_filter(function(tool)
					return tool ~= "ansible-lint"
				end, opts.ensure_installed or {})
			end
		end,
	},
	{
		"neovim/nvim-lspconfig",
		init = function()
			-- nvim-ansible cobre os caminhos convencionais. Detecta também playbooks com outros nomes.
			vim.filetype.add({
				filename = {
					["ansible.cfg"] = "dosini.ansible_config",
					["inventory.ini"] = "dosini.ansible_inventory",
				},
				pattern = { [".*%.ya?ml"] = detect_playbook },
			})
		end,
		opts = {
			servers = {
				ansiblels = {
					-- O lint exige Ansible em um ambiente Linux. O ALS ainda valida YAML no Windows.
					settings = is_windows and { ansible = { validation = { lint = { enabled = false } } } } or nil,
					root_dir = function(bufnr, on_dir)
						local root = vim.fs.root(bufnr, {
							{ "ansible.cfg", ".ansible-lint", ".ansible-lint.yml", ".ansible-lint.yaml" },
							".git",
						})
						on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
					end,
				},
			},
		},
	},
}
