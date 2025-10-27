return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, {
      function()
        local env = os.getenv("CONDA_DEFAULT_ENV") or "base"
        return { env, "filetype" }
      end,
    })
  end,
}
