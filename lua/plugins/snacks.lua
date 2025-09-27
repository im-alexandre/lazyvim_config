return {
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      -- garante que existe a tabela
      opts.picker = opts.picker or {}
      -- só adiciona/ajusta o que você quer
      opts.picker.ignored = true
    end,
  },
}
