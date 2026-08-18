return {
	{
		"iamcco/markdown-preview.nvim",

		init = function()
			vim.g.mkdp_markdown_css = vim.fn.stdpath("config") .. "/markdown-preview.css"

			vim.g.mkdp_page_title = "${name}"
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {},
				uml = {},
				maid = {},
				disable_sync_scroll = 0,
				sync_scroll_type = "relative",
				hide_yaml_meta = 1,
				sequence_diagrams = {},
				flowchart_diagrams = {},
				content_editable = false,
				disable_filename = 1,
				toc = {},
			}
		end,
	},
}
