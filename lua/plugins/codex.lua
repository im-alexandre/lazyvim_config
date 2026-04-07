local OPEN_DELAY_MS = 300

local function with_codex_open(action)
	local codex = require("codex")
	local codex_ui = require("codex.ui")

	if codex_ui.is_open() then
		action()
		return
	end

	codex.toggle()
	vim.defer_fn(function()
		if codex_ui.is_open() then
			action()
			return
		end

		vim.notify("codex.nvim: failed to open Codex window", vim.log.levels.WARN)
	end, OPEN_DELAY_MS)
end

local function focus_codex()
	vim.schedule(function()
		vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "x", false)
		require("codex.ui").focus()
		vim.cmd("startinsert")
	end)
end

local function build_selection_payload()
	local selection = require("codex.terminal")._debug_get_visual_selection()
	if not selection or not selection.text or selection.text == "" then
		vim.notify("codex.nvim: visual selection is empty", vim.log.levels.WARN)
		return nil
	end

	local filename = vim.api.nvim_buf_get_name(selection.bufnr)
	if filename == "" then
		filename = "[No Name]"
	else
		filename = vim.fn.fnamemodify(filename, ":t")
	end

	local payload =
		string.format("File: %s:%d-%d\n\n%s", filename, selection.start_line, selection.end_line, selection.text)

	if payload:sub(-1) ~= "\n" then
		payload = payload .. " \n\n"
	end

	return payload
end

local function build_buffer_payload()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		vim.notify("codex.nvim: buffer has no name", vim.log.levels.WARN)
		return nil
	end

	local display = vim.fn.fnamemodify(filename, ":.")
	return string.format("File: %s\nThis buffer was shared; please read it from disk.\n\n", display)
end

return {
	"rhart92/codex.nvim",
	lazy = false,
	init = function()
		vim.o.autoread = true
	end,
	keys = {
		{
			"<leader>X",
			nil,
			desc = "Codex",
		},
		{
			"<leader>Xt",
			function()
				require("codex").toggle()
			end,
			desc = "Codex: toggle",
		},
		{
			"<leader>Xs",
			function()
				local payload = build_selection_payload()
				if not payload then
					return
				end

				with_codex_open(function()
					require("codex").send(payload, { submit = false })
					focus_codex()
				end)
			end,
			mode = "v",
			desc = "Codex: send selection",
		},
		{
			"<leader>Xb",
			function()
				local payload = build_buffer_payload()
				if not payload then
					return
				end

				with_codex_open(function()
					require("codex").send(payload, { submit = false })
					focus_codex()
				end)
			end,
			desc = "Codex: send buffer",
		},
	},
}
