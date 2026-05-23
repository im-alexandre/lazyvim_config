return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = {
        javascript = { "eslint" },
        typescript = { "eslint" },
        dockerfile = { "hadolint" },
        markdown = { "markdownlint-cli2" },
      }

      local lint = require("lint")
      lint.linters["markdownlint-cli2"].args = {
        "--config",
        ".markdownlint-cli2.jsonc",
        "-",
      }
    end,
  },
}
