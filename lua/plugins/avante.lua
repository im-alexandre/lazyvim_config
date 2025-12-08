-- Lê API keys de arquivos
-- Estrutura de providers e seus modelos
local api_key_files = {
  "openai_api_key",
  "anthropic_api_key",
  "gemini_api_key",
}

for _, key_name in ipairs(api_key_files) do
  local key_file = vim.fn.stdpath("config") .. "/." .. key_name
  local key_value = vim.fn.filereadable(key_file) == 1 and vim.fn.readfile(key_file)[1] or nil
  local env_variable_name = string.upper(key_name)
  local avante_env_variable_name = "AVANTE_" .. env_variable_name
  vim.env[avante_env_variable_name] = key_value
  vim.env[env_variable_name] = vim.env[avante_env_variable_name] or key_value
end

local available_providers = {
  {
    name = "openai",
    display = "OpenAI",
    models = {
      {
        name = "gpt-5.1",
        desc = "Modelo principal, rápido e estável — uso geral de código",
      },
      {
        name = "gpt-5.1-thinking",
        desc = "Raciocínio profundo — ideal para refatorações grandes e análise pesada",
      },
      {
        name = "gpt-4.1",
        desc = "Mais barato e rápido, ainda muito bom para programação",
      },
      {
        name = "gpt-4o",
        desc = "Ótimo custo-benefício para tarefas gerais de texto e código",
      },
    },
  },
  {
    name = "claude",
    display = "Anthropic Claude",
    models = {
      {
        name = "claude-opus-4-5",
        desc = "Mais avançado — raciocínio profundo e tarefas autônomas complexas (mais caro)",
      },
      {
        name = "claude-sonnet-4-5",
        desc = "Equilibrado — excelente para código, agentes e uso geral (recomendado)",
      },
      {
        name = "claude-opus-4",
        desc = "Anterior ao 4.5 — raciocínio profundo com modo thinking (mais caro)",
      },
      {
        name = "claude-sonnet-4",
        desc = "Anterior ao 4.5 — rápido e eficiente para código (custo médio)",
      },
    },
  },
  {
    name = "gemini",
    display = "Google Gemini",
    models = {
      {
        name = "gemini-2.5-pro",
        desc = "Mais capaz — raciocínio complexo e geração avançada de código (mais lento)",
      },
      {
        name = "gemini-2.5-flash",
        desc = "Rápido e eficiente — baixa latência com capacidades de pensamento (recomendado)",
      },
    },
  },
}

-- Configuração padrão inicial
vim.g.avante_provider = vim.g.avante_provider or "claude"
vim.g.avante_model = vim.g.avante_model or "claude-sonnet-4-5"
vim.g.avante_statusline = string.format("Avante: %s/%s", vim.g.avante_provider, vim.g.avante_model)

-- Upvalues para manter o último opts e a instância do módulo avante
local current_opts = nil
local avante_mod = nil

return {
  "yetone/avante.nvim",
  event = "VeryLazy",

  opts = {
    provider = vim.g.avante_provider,
    mode = "legacy", -- enable codeblock/diff style replies

    providers = {
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-5.1",
        api_key_name = "AVANTE_OPENAI_API_KEY",
        use_response_api = true,
        support_previous_response_id = true,
        -- Lista de modelos disponíveis para o comando :AvanteModels
        model_names = {
          "gpt-5.1",
          "gpt-5.1-thinking",
          "gpt-4.1",
          "gpt-4o",
        },
        extra_request_body = {
          temperature = 0.2,
          max_output_tokens = 4096,
        },
      },
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-5",
        api_key_name = "AVANTE_ANTHROPIC_API_KEY",
        timeout = 30000,
        -- Lista de modelos disponíveis para o comando :AvanteModels
        model_names = {
          "claude-opus-4-5",
          "claude-sonnet-4-5",
          "claude-opus-4",
          "claude-sonnet-4",
        },
        extra_request_body = {
          temperature = 0.2,
          max_tokens = 4096,
        },
      },
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-2.5-flash",
        api_key_name = "AVANTE_GEMINI_API_KEY",
        -- Lista de modelos disponíveis para o comando :AvanteModels
        model_names = {
          "gemini-2.5-pro",
          "gemini-2.5-flash",
        },
        extra_request_body = {
          temperature = 0.2,
          maxOutputTokens = 4096,
        },
      },
    },

    behaviour = {
      auto_apply_diff_after_generation = true, -- aplica patches automaticamente
      minimize_diff = true,
    },

    -- mapeamentos de diff/patch
    mappings = {
      diff = {
        -- aplicar apenas o hunk/patch selecionado
        accept = "a",
        -- aplicar todos os hunks da resposta
        accept_all = "A",
        -- rejeitar somente o hunk/patch selecionado
        reject = "x",
        -- rejeitar todos
        reject_all = "X",
        next = "]d",
        prev = "[d",
      },
    },
  },

  -- Config extra: setup + notify + comando AvanteChange + keymap
  config = function(_, opts)
    -- Ajusta reasoning_effort/thinking para modelos específicos
    local provider_name = opts.provider or vim.g.avante_provider
    local providers = opts.providers or {}
    local provider_cfg = providers[provider_name] or {}
    local model_name = provider_cfg.model or vim.g.avante_model

    -- Para OpenAI, ajusta reasoning_effort se for modelo thinking
    if provider_name == "openai" then
      provider_cfg.extra_request_body = provider_cfg.extra_request_body or {}
      if tostring(model_name):find("thinking") then
        provider_cfg.extra_request_body.reasoning_effort = provider_cfg.extra_request_body.reasoning_effort or "medium"
      else
        provider_cfg.extra_request_body.reasoning_effort = nil
      end
    end

    opts.providers[provider_name] = provider_cfg

    -- Guarda opts/instância em upvalues para o AvanteChange
    current_opts = opts
    avante_mod = require("avante")

    -- Setup normal do Avante
    avante_mod.setup(opts)

    -- Atualiza variáveis globais de status
    vim.g.avante_provider = provider_name
    vim.g.avante_model = model_name
    vim.g.avante_statusline = string.format("Avante: %s/%s", vim.g.avante_provider, vim.g.avante_model)

    -- Notify na inicialização
    vim.notify(
      string.format("Avante: %s | %s", provider_name, model_name),
      vim.log.levels.INFO,
      { title = "Avante.nvim" }
    )

    ---------------------------------------------------------------------------
    -- Comando AvanteSwitch: escolher provider e depois modelo (com descrições)
    -- Nota: Use :AvanteModels para o seletor nativo (sem descrições)
    ---------------------------------------------------------------------------
    if not vim.g.avante_switch_defined then
      vim.api.nvim_create_user_command("AvanteSwitch", function()
        -- Primeiro passo: selecionar o provider
        local provider_list = {}
        for _, p in ipairs(available_providers) do
          table.insert(provider_list, p.display)
        end

        vim.ui.select(provider_list, { prompt = "🚀 Selecione o Provider:" }, function(choice, idx)
          if not choice or not idx then
            return
          end

          local selected_provider = available_providers[idx]
          if not selected_provider then
            return
          end

          -- Segundo passo: selecionar o modelo
          local model_list = {}
          for _, m in ipairs(selected_provider.models) do
            table.insert(model_list, string.format("%s — %s", m.name, m.desc))
          end

          vim.ui.select(
            model_list,
            { prompt = string.format("🧠 Selecione o modelo (%s):", selected_provider.display) },
            function(model_choice, model_idx)
              if not model_choice or not model_idx then
                return
              end

              local selected_model = selected_provider.models[model_idx]
              if not selected_model then
                return
              end

              local provider = selected_provider.name
              local model = selected_model.name

              -- Atualiza globais
              vim.g.avante_provider = provider
              vim.g.avante_model = model
              vim.g.avante_statusline = string.format("Avante: %s/%s", provider, model)

              -- Ajusta opts em memória e reaplica setup
              if current_opts and current_opts.providers and current_opts.providers[provider] then
                current_opts.provider = provider

                local cfg = current_opts.providers[provider]
                cfg.model = model

                -- Ajusta reasoning_effort para modelos thinking (OpenAI)
                if provider == "openai" then
                  cfg.extra_request_body = cfg.extra_request_body or {}
                  if tostring(model):find("thinking") then
                    cfg.extra_request_body.reasoning_effort = cfg.extra_request_body.reasoning_effort or "medium"
                  else
                    cfg.extra_request_body.reasoning_effort = nil
                  end
                end

                current_opts.providers[provider] = cfg

                -- Reaplica a configuração no Avante
                if avante_mod then
                  avante_mod.setup(current_opts)
                end
              end

              -- Usa a API interna do Avante para trocar provider/modelo
              -- Isso garante que o estado interno seja atualizado corretamente
              pcall(function()
                require("avante.config").override({ provider = provider })
                if avante_mod and avante_mod.api and avante_mod.api.switch_provider then
                  avante_mod.api.switch_provider(provider, model)
                end
              end)

              -- Limpa a conversa atual se o Avante estiver aberto
              local avante_open = false
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname:match("Avante") then
                  avante_open = true
                  break
                end
              end

              if avante_open then
                vim.cmd("AvanteToggle")
                vim.defer_fn(function()
                  vim.cmd("AvanteToggle")
                  vim.notify(
                    string.format("Avante: %s → %s\nNova conversa iniciada!", provider, model),
                    vim.log.levels.INFO,
                    { title = "AvanteSwitch" }
                  )
                end, 100)
              else
                vim.notify(
                  string.format("Avante: %s → %s\nAbra o Avante para usar o novo modelo!", provider, model),
                  vim.log.levels.INFO,
                  { title = "AvanteSwitch" }
                )
              end
            end
          )
        end)
      end, {})

      vim.g.avante_switch_defined = true
    end

    ---------------------------------------------------------------------------
    -- Atalho para abrir o AvanteSwitch rapidamente
    ---------------------------------------------------------------------------
    vim.keymap.set(
      "n",
      "<leader>as",
      ":AvanteSwitch<CR>",
      { desc = "Trocar provider/modelo do Avante.nvim", noremap = true, silent = true }
    )
  end,
}
