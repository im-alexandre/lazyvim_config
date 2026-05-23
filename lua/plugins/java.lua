return {
  {
    "mfussenegger/nvim-jdtls",
    enabled = function()
      return vim.fn.executable("java") == 1
    end,
  },
}
