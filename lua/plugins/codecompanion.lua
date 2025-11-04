-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- Modelo centralizado
    local ai_model = "gpt-4o-mini"

    -- Lê a chave crua
    local keyfile = vim.fn.stdpath("config") .. "/.open_api_key"
    local key = vim.fn.filereadable(keyfile) == 1 and vim.fn.readfile(keyfile)[1] or nil
    if not key or key == "" then
      vim.notify("❌ OPENAI API key não encontrada em " .. keyfile, vim.log.levels.ERROR)
      return
    end

    local adapters = require("codecompanion.adapters")

    require("codecompanion").setup({
      adapters = {
        http = {
          -- ⚠️ IMPORTANTE: usar função que retorna adapters.extend(...)
          openai = function()
            return adapters.extend("openai", {
              env = { api_key = key },
              schema = { model = { default = ai_model } },
              -- (Opcional) forçar roles explicitamente, se quiser:
              -- roles = { user = "user", assistant = "assistant", system = "system" },
            })
          end,
        },
      },
      strategies = {
        chat = { adapter = "openai", model = ai_model },
        inline = { adapter = "openai", model = ai_model },
      },
      opts = { log_level = "WARN" },
    })

    -- Atalhos
    vim.keymap.set("n", "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Chat CodeCompanion" })
    vim.keymap.set("v", "<leader>ae", "<cmd>CodeCompanionChat Add<CR>", { desc = "Mandar seleção pro chat" })
  end,
}
