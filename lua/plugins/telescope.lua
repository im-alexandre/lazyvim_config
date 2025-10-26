return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    -- garantir que as tabelas existem
    opts.defaults = opts.defaults or {}
    opts.pickers = opts.pickers or {}

    -- adiciona comportamento ao find_files (sem sobrescrever o resto)
    opts.pickers.find_files = vim.tbl_deep_extend("force", opts.pickers.find_files or {}, {
      hidden = true, -- inclui dotfiles
      -- no_ignore = true, -- inclui arquivos .gitignore
    })

    return opts
  end,
}
