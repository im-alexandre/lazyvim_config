return {
  "yetone/avante.nvim",
  event = "VeryLazy",

  config = function()
    -- Caminho do arquivo contendo a chave:
    -- (~/.config/nvim/.openai_api_key)
    local key_path = vim.fn.stdpath("config") .. "/.openai_api_key"

    -- Tenta ler o arquivo e aplicar a chave na variável de ambiente
    local ok, key_file = pcall(function()
      return vim.fn.readfile(key_path)[1]
    end)

    if not ok or not key_file or key_file == "" then
      vim.notify("AVANTE: não encontrei a chave em " .. key_path, vim.log.levels.ERROR)
    else
      vim.env.OPENAI_API_KEY = key_file
    end

    -------------------------------------------------------------------
    -- CONFIGURAÇÃO AVANTE.NVIM - modelo único, ideal para Ask/Edit
    -------------------------------------------------------------------

    require("avante").setup({
      provider = "openai",
      model = "gpt-5.1-codex-max", -- nosso modelo principal e único
      temperature = 0.2,
      top_p = 0.9,
      max_tokens = 4096,
      reasoning = true,
      ui = { floating = true },
    })
  end,
}
