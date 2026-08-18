local M = {}

local state = {
	buffer = nil,
	source = nil,
	server = nil,
	group = nil,
	render = nil,
	port = 8890,
}

local function notify_error(message)
	vim.schedule(function()
		vim.notify(message, vim.log.levels.ERROR, {
			title = "Pandoc Preview",
		})
	end)
end

local function write_preview_files()
	local config = vim.fn.stdpath("config")
	local cache = vim.fn.stdpath("cache")
	local css_path = vim.fs.joinpath(config, "markdown-preview.css")
	local header_path = vim.fs.joinpath(cache, "pandoc-preview-header.html")
	local reload_path = vim.fs.joinpath(cache, "pandoc-preview-reload.html")

	local css = ""

	if vim.fn.filereadable(css_path) == 1 then
		css = table.concat(vim.fn.readfile(css_path), "\n")
	end

	local version = tostring(vim.uv.hrtime())

	vim.fn.writefile({
		'<meta name="pandoc-preview-version" content="' .. version .. '">',
		"<style>",
		css,
		[[
body {
  box-sizing: border-box;
  width: min(96vw, 1800px);
  max-width: none;
  margin: 0 auto;
  padding: 32px clamp(24px, 4vw, 72px);
  line-height: 1.65;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  padding: 0.5rem 0.75rem;
  border: 1px solid currentColor;
}

pre {
  overflow-x: auto;
}

img,
svg {
  max-width: 100%;
  height: auto;
}

[data-custom-style="Strong"] {
  font-weight: 700;
}
]],
		"</style>",
	}, header_path)

	vim.fn.writefile({
		"<script>",
		"(() => {",
		"  const current = document.querySelector(",
		"    'meta[name=\"pandoc-preview-version\"]'",
		"  )?.content;",
		"",
		"  setInterval(async () => {",
		"    try {",
		"      const response = await fetch(",
		"        location.pathname + '?t=' + Date.now(),",
		"        { cache: 'no-store' }",
		"      );",
		"",
		"      const html = await response.text();",
		"      const match = html.match(",
		'        /<meta name="pandoc-preview-version" content="([^"]+)">/',
		"      );",
		"",
		"      if (match && match[1] !== current) {",
		"        location.reload();",
		"      }",
		"    } catch (_) {}",
		"  }, 600);",
		"})();",
		"</script>",
	}, reload_path)

	return header_path, reload_path
end

local function render()
	if not state.buffer or not vim.api.nvim_buf_is_valid(state.buffer) then
		return
	end

	local directory = vim.fs.dirname(state.source)
	local output = vim.fs.joinpath(directory, ".pandoc-preview.html")

	local header, reload = write_preview_files()
	local content = table.concat(vim.api.nvim_buf_get_lines(state.buffer, 0, -1, false), "\n")

	if state.render then
		state.render:kill(15)
	end

	local pandoc = [[C:\Users\imale\AppData\Local\Pandoc\pandoc.exe]]

	state.render = vim.system({
		pandoc,
		"--from=markdown" .. "+grid_tables" .. "+fenced_divs" .. "+bracketed_spans" .. "+link_attributes",
		"--to=html5",
		"--standalone",
		"--mathjax",
		"--resource-path=" .. directory,
		"--include-in-header=" .. header,
		"--include-after-body=" .. reload,
		"--metadata=pagetitle:" .. vim.fn.fnamemodify(state.source, ":t:r"),
		"--output=" .. output,
	}, {
		cwd = directory,
		stdin = content,
		text = true,
	}, function(result)
		if result.code ~= 0 then
			notify_error(result.stderr)
		end
	end)
end

local function stop()
	if state.server then
		vim.fn.jobstop(state.server)
	end

	if state.render then
		state.render:kill(15)
	end

	if state.group then
		pcall(vim.api.nvim_del_augroup_by_id, state.group)
	end

	state.buffer = nil
	state.source = nil
	state.server = nil
	state.group = nil
	state.render = nil
end

local function start()
	if vim.fn.executable("pandoc") ~= 1 then
		notify_error("pandoc não encontrado no PATH")
		return
	end

	if vim.fn.executable("python") ~= 1 then
		notify_error("python não encontrado no PATH")
		return
	end

	stop()

	state.buffer = vim.api.nvim_get_current_buf()
	state.source = vim.api.nvim_buf_get_name(state.buffer)

	if state.source == "" then
		notify_error("salve o arquivo antes de abrir o preview")
		return
	end

	local directory = vim.fs.dirname(state.source)

	state.server = vim.fn.jobstart({
		"python",
		"-m",
		"http.server",
		tostring(state.port),
		"--bind",
		"127.0.0.1",
		"--directory",
		directory,
	}, {
		cwd = directory,
	})

	state.group = vim.api.nvim_create_augroup("PandocPreview", { clear = true })

	vim.api.nvim_create_autocmd({
		"TextChanged",
		"TextChangedI",
		"BufWritePost",
	}, {
		group = state.group,
		buffer = state.buffer,
		callback = function()
			vim.defer_fn(render, 250)
		end,
	})

	render()

	vim.defer_fn(function()
		vim.ui.open("http://127.0.0.1:" .. state.port .. "/.pandoc-preview.html")
	end, 400)
end

vim.api.nvim_create_user_command("PandocPreview", start, {})

vim.api.nvim_create_user_command("PandocPreviewStop", stop, {})

vim.keymap.set("n", "<leader>mp", start, {
	desc = "Pandoc preview",
})

vim.keymap.set("n", "<leader>mP", stop, {
	desc = "Stop Pandoc preview",
})

return M
