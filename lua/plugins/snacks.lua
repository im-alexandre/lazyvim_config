return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- merge sem sobrescrever, estendendo
    opts.animate = vim.tbl_deep_extend("force", opts.animate or {}, { enabled = false })
    opts.scroll = vim.tbl_deep_extend("force", opts.scroll or {}, { enabled = false })
    opts.indent = vim.tbl_deep_extend("force", opts.indent or {}, { animate = { enabled = false } })
    opts.statuscolumn = vim.tbl_deep_extend("force", opts.statuscolumn or {}, { enabled = false })

    opts.finder = vim.tbl_deep_extend("force", opts.finder or {}, {
      cmd = "fd",
      args = {
        "--type",
        "f",
        "--hidden",
        "--exclude",
        ".git",
        "--ignore-file",
        ".gitignore",
      },
    })

    return opts
  end,
}
