return {
	{
		"kiyoon/jupynium.nvim",
		build = "conda run --no-capture-output -n base pip install .",
		dependencies = {
			"rcarriga/nvim-notify",
			"stevearc/dressing.nvim",
		},
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
			local jupynium_python = "C:/tools/miniforge3/python.exe"
			local jupynium_pythonw = "C:/tools/miniforge3/pythonw.exe"
			local jupynium_group = vim.api.nvim_create_augroup("user-jupynium", { clear = true })

			require("jupynium").setup({
				python_host = { jupynium_python },
				jupyter_command = { jupynium_pythonw, "-m", "jupyter" },
				default_notebook_URL = "http://localhost:8888/nbclassic",
				jupynium_file_pattern = { "*.py" },
				use_default_keybindings = false,
				textobjects = {
					use_default_keybindings = false,
				},

				auto_start_server = {
					enable = false,
					file_pattern = { "*.py" },
				},

				auto_attach_to_server = {
					enable = false,
					file_pattern = { "*.py" },
				},

				auto_start_sync = {
					enable = false,
					file_pattern = { "*.py" },
				},

				auto_download_ipynb = false,
				auto_close_tab = false,
				shortsighted = true,
			})

			local job_ids = {}
			local services_started = false

			local function start_services()
				if services_started then
					return false
				end

				local nbclassic_jid = vim.fn.jobstart({
					jupynium_pythonw,
					"-m",
					"nbclassic",
					"--no-browser",
				}, { detach = false })
				if nbclassic_jid > 0 then
					table.insert(job_ids, nbclassic_jid)
				end

				vim.defer_fn(function()
					local jupynium_jid = vim.fn.jobstart({
						jupynium_pythonw,
						"-m",
						"jupynium",
						"--nvim_listen_addr",
						vim.v.servername,
					}, { detach = false })
					if jupynium_jid > 0 then
						table.insert(job_ids, jupynium_jid)
					end
				end, 1500)

				services_started = true
				return true
			end

			vim.api.nvim_create_autocmd("VimLeave", {
				group = jupynium_group,
				callback = function()
					for _, jid in ipairs(job_ids) do
						if jid > 0 then
							pcall(vim.fn.jobstop, jid)
						end
					end
				end,
			})

			vim.keymap.set("n", "<leader>js", function()
				start_services()
			end, { desc = "Start nbclassic + Jupynium and attach" })

			vim.keymap.set("n", "<leader>je", function()
				vim.cmd("JupyniumExecuteSelectedCells")
				require("jupynium.textobj").goto_next_cell_separator()
			end, { desc = "Execute current cell and jump to next" })

			vim.keymap.set(
				"n",
				"<leader>ja",
				"ggVG<cmd>JupyniumExecuteSelectedCells<CR><Esc>",
				{ desc = "Execute all cells" }
			)

			vim.keymap.set("n", "<leader>jn", function()
				require("jupynium.textobj").goto_next_cell_separator()
			end, { desc = "Jump to next cell" })

			vim.keymap.set("n", "<leader>jN", function()
				require("jupynium.textobj").goto_previous_cell_separator()
			end, { desc = "Jump to previous cell" })

			vim.keymap.set("n", "<leader>jk", "<cmd>JupyniumKernelSelect<CR>", {
				desc = "Select Jupyter kernel",
			})
		end,
	},
}
