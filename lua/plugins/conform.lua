return {
  "stevearc/conform.nvim",
  opts = {
    -- formato via <leader>ca / :Format / etc
    formatters_by_ft = {
      -- Web
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      javascriptreact = { "prettierd", "prettier" },
      typescriptreact = { "prettierd", "prettier" },
      json = { "prettierd", "prettier" },
      jsonc = { "prettierd", "prettier" },
      yaml = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },

      -- Lua / Shell
      lua = { "stylua" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      zsh = { "shfmt" },

      -- Python (ordem: ruff (fix/imports) + format)
      python = { "ruff_fix", "ruff_format" },

      -- Java
      java = { "google-java-format" },

      -- Django/Jinja/HTML templates
      htmldjango = { "djlint" },
      jinja = { "djlint" },
      django = { "djlint" },

      -- Ferramentas úteis por filetype
      jq = { "jq" },
    },

    -- fallback: se não tiver ft mapeado, tenta LSP
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 3000,
    },
  },
}
