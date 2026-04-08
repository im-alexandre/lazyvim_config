return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        dockerfile = { "hadolint" },
      }
    end,
  },
}
