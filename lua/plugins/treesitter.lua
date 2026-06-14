return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = {
        "lua",
        "luadoc",
        "powershell",
        "vim",
        "vimdoc",
      }
    end,
  },
}
