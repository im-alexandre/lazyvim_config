local visual_cwd = vim.env.NVIM_PSREADLINE_VISUAL == "1" and vim.env.PSREADLINE_VISUAL_CWD or nil

if not visual_cwd or visual_cwd == "" or vim.fn.isdirectory(visual_cwd) ~= 1 then
	return
end

visual_cwd = vim.fs.normalize(visual_cwd)

local function is_psreadline_visual_buffer(buf)
	local name = vim.api.nvim_buf_get_name(buf or 0)
	if name == "" then
		return false
	end

	name = vim.fs.normalize(name)

	return name:match("[/\\]%.psreadline%-edit%-.*%.ps1$")
end

local function psreadline_root(buf)
	if is_psreadline_visual_buffer(buf) then
		return visual_cwd
	end
end

local function apply_visual_cwd()
	vim.fn.chdir(visual_cwd)
	pcall(vim.cmd, "tcd " .. vim.fn.fnameescape(visual_cwd))
	pcall(vim.cmd, "lcd " .. vim.fn.fnameescape(visual_cwd))
end

local function visual_git_root()
	local git = vim.fs.find(".git", { path = visual_cwd, upward = true })[1]
	return git and vim.fn.fnamemodify(git, ":h") or visual_cwd
end

apply_visual_cwd()

vim.g.root_spec = vim.g.root_spec or { "lsp", { ".git", "lua" }, "cwd" }
table.insert(vim.g.root_spec, 1, psreadline_root)

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		apply_visual_cwd()
	end,
})

vim.keymap.set("n", "<leader>e", function()
	local ok, snacks = pcall(require, "snacks")
	if ok then
		snacks.explorer({ cwd = visual_cwd })
	end
end, { desc = "Explorer Snacks (PSReadLine cwd)" })

vim.keymap.set("n", "<leader>E", function()
	local ok, snacks = pcall(require, "snacks")
	if ok then
		snacks.explorer({ cwd = visual_cwd })
	end
end, { desc = "Explorer Snacks (PSReadLine cwd)" })

vim.keymap.set("n", "<leader>gg", function()
	local ok, snacks = pcall(require, "snacks")
	if ok then
		snacks.lazygit({ cwd = visual_git_root() })
	end
end, { desc = "Lazygit (PSReadLine cwd)" })
