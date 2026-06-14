return {
  "rafamadriz/friendly-snippets",
  dependencies = { "L3MON4D3/LuaSnip" },
  event = "InsertEnter",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load({
      include = { "lua" },
    })

    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
}
