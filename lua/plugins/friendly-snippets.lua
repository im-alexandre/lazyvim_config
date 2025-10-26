return {
  "rafamadriz/friendly-snippets",
  dependencies = { "L3MON4D3/LuaSnip" },
  event = "InsertEnter",
  config = function()
    -- 1️⃣ Carrega TODOS os snippets padrão, exceto PowerShell
    require("luasnip.loaders.from_vscode").lazy_load({
      exclude = { "PowerShell", "ps1" },
    })

    -- 2️⃣ Carrega os SEUS snippets
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
      include = { "powershell", "ps1" },
    })
  end,
}
