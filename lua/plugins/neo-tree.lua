return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    -- garantir que a tabela existe
    opts.filesystem = opts.filesystem or {}
    opts.filesystem.filtered_items = opts.filesystem.filtered_items or {}

    -- estende sem sobrescrever o resto
    opts.filesystem.filtered_items.visible = true
    opts.filesystem.filtered_items.hide_gitignored = false
    opts.filesystem.filtered_items.hide_dotfiles = false

    return opts
  end,
}
