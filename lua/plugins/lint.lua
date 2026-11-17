return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
        markdown = { "markdownlint-cli2" },
        python = { "ruff" },
      },
    },
  },
}
