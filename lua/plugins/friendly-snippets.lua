return {
  "rafamadriz/friendly-snippets",
  dependencies = { "L3MON4D3/LuaSnip" },
  event = "InsertEnter",
  config = function()
    -- 1️⃣ Carrega TODOS os snippets padrão, exceto PowerShell/ps1
    require("luasnip.loaders.from_vscode").lazy_load({
      exclude = { "PowerShell", "powershell", "ps1" },
    })

    -- 2️⃣ Carrega os SEUS snippets (sobrescrevem os anteriores)
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
}
