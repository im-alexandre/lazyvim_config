-- Lê API keys de arquivos
-- Estrutura de providers e seus modelos
local DEFAULT_PROVIDER = "openai"
local DEFAULT_MODEL = "gpt-4o-mini"

local model_names = {
  "gpt-5.1",
  "gpt-5.1-thinking",
  "gpt-4.1",
  "gpt-4o",
}

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

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,

  -- Dependências mínimas recomendadas pelo próprio Avante
  -- (se já estiverem em outro lugar da sua config, pode remover daqui)
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  ---@type avante.Config
  opts = {
    ---------------------------------------------------------------------------
    -- 1) Provider padrão
    ---------------------------------------------------------------------------
    provider = "openai",

    ---------------------------------------------------------------------------
    -- 2) Config do provider OpenAI
    --    Importante: use "gpt-5.1" (modelo de chat).
    --    NÃO use gpt-5.1-codex-max aqui, porque ele é de /v1/completions
    --    e o Avante usa /v1/chat/completions por baixo dos panos.
    ---------------------------------------------------------------------------
    providers = {
      openai = {
        -- usa o endpoint padrão do Avante para OpenAI (não precisa setar)
        -- endpoint = "https://api.openai.com/v1/chat/completions",

        model = "gpt-5.2",
        api_key_name = "OPENAI_API_KEY", -- pega do ambiente

        timeout = 30000, -- ms

        -- se quiser mexer em temperatura / max tokens etc:
        -- extra_request_body = {
        --   temperature = 0.2,
        --   -- max_completion_tokens = 8192,
        -- },
      },
    },

    ---------------------------------------------------------------------------
    -- 3) Comportamento: diffs, aplicação, keymaps etc.
    ---------------------------------------------------------------------------
    behaviour = {
      auto_suggestions = false, -- deixa só o modo Ask mesmo
      auto_set_highlight_group = true,
      auto_set_keymaps = true,

      -- Fluxo “ver resposta -> aplicar manualmente com 'a' no sidebar”
      auto_apply_diff_after_generation = false,

      support_paste_from_clipboard = false,
      minimize_diff = true, -- remove linhas iguais do diff
      enable_token_counting = true,
      auto_add_current_file = true,
      auto_approve_tool_permissions = true,
      confirmation_ui_style = "inline_buttons",
      acp_follow_agent_locations = true,
    },

    ---------------------------------------------------------------------------
    -- 4) Mapeamentos padrão (inclui 'a' para aplicar patch no sidebar)
    ---------------------------------------------------------------------------
    mappings = {
      diff = {
        ours = "co",
        theirs = "ct",
        all_theirs = "ca",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      suggestion = {
        accept = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a", -- <- é esse que você usa para aplicar o patch
        retry_user_request = "r",
        edit_user_request = "e",
        switch_windows = "<Tab>",
        reverse_switch_windows = "<S-Tab>",
        remove_file = "d",
        add_file = "@",
        close = { "<Esc>", "q" },
      },
    },
  },
}
