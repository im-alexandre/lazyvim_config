return {
  -- LSP servers
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- Python
        "pyright",
        "ruff",
        "djlsp",
        "jinja_lsp",

        -- Web
        "ts_ls",
        "eslint",
        "html",
        "cssls",

        -- Lua
        "lua_ls",

        -- Docker
        "dockerls",
        "docker_compose_language_service",

        -- Shell
        "bashls",

        -- Config
        "jsonls",
        "yamlls",
        "marksman",

        -- PowerShell LSP
        "powershell_es",
      },
    },
  },

  -- Non-LSP tools (formatters/linters/etc)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
        "prettier",
        "stylua",
        "shfmt",
        "ruff",
        "djlint",
        "hadolint",
        "jq",
      },
      run_on_start = true,
    },
  },
}
