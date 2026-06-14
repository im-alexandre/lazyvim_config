return {
  -- LSP servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "powershell_es",
      },
    },
  },

  -- Non-LSP tools (formatters/linters/etc)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "stylua",
      },
      run_on_start = true,
    },
  },
}
