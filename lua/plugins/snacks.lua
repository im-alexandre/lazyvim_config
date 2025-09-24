return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- garante que existe a tabela
      opts.picker = opts.picker or {}
      opts.picker.sources = opts.picker.sources or {}
      opts.picker.sources.explorer = opts.picker.sources.explorer or {}

      -- só adiciona/ajusta o que você quer
      opts.picker.sources.explorer.ignored = true
    end,
  },
}
