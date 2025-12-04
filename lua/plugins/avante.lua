-- Defina o provider padrão
local DEFAULT_PROVIDER = "openai"
local DEFAULT_MODEL = "gpt-4o-mini"

-- Carrega chaves de API
local PROVIDERS = { "gemini", "openai" }
local ok, err = pcall(function()
  for _, provider in ipairs(PROVIDERS) do
    local key_path = vim.fn.stdpath("config") .. "/." .. provider .. "_api_key"

    if vim.fn.filereadable(key_path) == 1 then
      local key = vim.fn.readfile(key_path)[1]
      vim.env[string.upper(provider) .. "_API_KEY"] = key
    end
  end
end)

if not ok then
  vim.notify("Erro nas chaves de API: " .. tostring(err), vim.log.levels.ERROR)
end

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  config = function()
    -- Mapa de Modelos
    local available_models = {
      ["openai:gpt-4o-mini"] = { provider = "openai", model = "gpt-4o-mini" },
      ["openai:gpt-4o"] = { provider = "openai", model = "gpt-4o" },
      ["openai:gpt-4.1"] = { provider = "openai", model = "gpt-4.1" },
      ["openai:gpt-5"] = { provider = "openai", model = "gpt-5" },
      ["openai:gpt-5-codex-max"] = { provider = "openai", model = "gpt-5-codex-max" },
      ["gemini:gemini-3-pro-preview"] = { provider = "gemini", model = "gemini-3-pro-preview" },
      ["gemini:gemini-2.5-pro"] = { provider = "gemini", model = "gemini-2.5-pro" },
      ["gemini:gemini-2.5-flash"] = { provider = "gemini", model = "gemini-2.5-flash" },
    }

    local function setup_avante(selection_key)
      local config = available_models[selection_key]
      if not config then
        config = { provider = DEFAULT_PROVIDER, model = DEFAULT_MODEL }
        selection_key = config.provider .. ":" .. config.model
      end

      require("avante").setup({
        provider = config.provider,

        -- Configurações Globais
        auto_suggestions_provider = config.provider,
        mode = "legacy",
        hints = { enabled = false },
        suggestion = { enabled = false },

        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1",
            model = config.model,
            timeout = 60000,
            max_tokens = 4096,
            extra_request_body = {
              temperature = 0,
            },
          },
          gemini = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
            model = config.model,
            timeout = 60000,
            extra_request_body = {
              generationConfig = {
                temperature = 0,
                maxOutputTokens = 8192,
              },
            },
          },
        },
      })

      vim.g.avante_current_selection = selection_key
      vim.notify("🚀 Avante: [" .. config.provider .. "] " .. config.model, vim.log.levels.INFO)
    end

    -- Inicialização
    local initial = vim.g.avante_current_selection or (DEFAULT_PROVIDER .. ":" .. DEFAULT_MODEL)
    setup_avante(initial)

    -- Comando Interativo: :AvanteChange
    vim.api.nvim_create_user_command("AvanteChange", function()
      -- 1. Extrair lista única de Providers
      local providers = {}
      local seen = {}
      for _, cfg in pairs(available_models) do
        if not seen[cfg.provider] then
          table.insert(providers, cfg.provider)
          seen[cfg.provider] = true
        end
      end
      table.sort(providers)

      -- 2. UI Select para o Provider
      vim.ui.select(providers, {
        prompt = "Selecione o Provider:",
      }, function(selected_provider)
        if not selected_provider then
          return
        end

        -- 3. Filtrar modelos do provider selecionado
        local provider_models = {}
        for key, cfg in pairs(available_models) do
          if cfg.provider == selected_provider then
            table.insert(provider_models, { name = cfg.model, key = key })
          end
        end
        -- Ordena alfabeticamente
        table.sort(provider_models, function(a, b)
          return a.name < b.name
        end)

        -- 4. UI Select para o Modelo
        vim.ui.select(provider_models, {
          prompt = "Selecione o Modelo (" .. selected_provider .. "):",
          format_item = function(item)
            return item.name
          end,
        }, function(choice)
          if choice then
            setup_avante(choice.key)
          end
        end)
      end)
    end, { nargs = 0 })
  end,
}
