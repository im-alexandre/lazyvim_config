PROVIDER = "openai"

PROVIDERS = {
  "gemini",
  "openai",
}

local ok, err = pcall(function()
  for index, provider in ipairs(PROVIDERS) do
    local key_path = vim.fn.stdpath("config") .. "\\." .. provider .. "_api_key"
    local key = vim.fn.readfile(key_path)[1]
    vim.env["AVANTE_" .. string.upper(provider) .. "_API_KEY"] = key
  end
end)

if not ok then
  vim.notify("❌ não encontrei a chave AVANTE_" .. string.upper(PROVIDER) .. "_API_KEY", vim.log.levels.WARN)
end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  config = function()
    -- modelos que você quer poder alternar
    local models = {
      ["gpt-4o-mini"] = "gpt-4o-mini",
      ["gpt-4o"] = "gpt-4o",
      ["gpt-4.1"] = "gpt-4.1",
      ["gpt-5"] = "gpt-5",
      ["gpt-5-codex-max"] = "gpt-5-codex-max", -- Modelo mais potente para código
    }

    -- função que (re)configura o Avante com o modelo escolhido
    local function setup_avante(model)
      model = models[model] or models["gpt-4o-mini"]

      require("avante").setup({
        mode = "legacy",
        hints = { enabled = false },
        suggestion = { enabled = false },
        provider = PROVIDER,
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1",
            api_key_name = "OPENAI_API_KEY",
            model = model,
            timeout = 60000,
            retry = 2,
            retry_delay = 30000,
            extra_request_body = {
              temperature = 0.2,
              max_completion_tokens = 1024,
            },
          },
        },
      })

      vim.g.avante_current_model = model
      vim.notify("Avante usando modelo: " .. model, vim.log.levels.INFO)
    end

    -- inicializa com o último modelo usado (se existir) ou gpt-4o
    setup_avante(vim.g.avante_current_model)

    -- comando para trocar de modelo em runtime
    vim.api.nvim_create_user_command("AvanteSwitch", function(opts)
      local wanted = vim.trim(opts.args)
      if not models[wanted] then
        vim.notify(
          "Modelo inválido: " .. wanted .. "\nDisponíveis: " .. table.concat(vim.tbl_keys(models), ", "),
          vim.log.levels.ERROR
        )
        return
      end

      setup_avante(wanted)
    end, {
      nargs = 1,
      complete = function()
        return vim.tbl_keys(models)
      end,
    })
  end,
}
