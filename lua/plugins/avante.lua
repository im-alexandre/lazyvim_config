return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,

  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },

  opts = {
    -- Força modo não-agentic
    mode = "legacy",
    provider = "openai",

    providers = {
      openai = {
        model = "gpt-5.2",
        api_key_name = "OPENAI_API_KEY",

        -- Mata qualquer comportamento agentic
        disable_tools = true,

        -- Deixa escolher manualmente se quiser trocar
        model_names = {
          "gpt-5.2",
          "gpt-4o-mini",
        },
      },
    },

    -- Comportamento: você vê o diff, nada aplica sozinho
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = false,
      auto_add_current_file = true,
      auto_approve_tool_permissions = false,
      acp_follow_agent_locations = false,
      auto_focus_on_diff_view = true,
      minimize_diff = true,
      enable_token_counting = true,
    },

    -- Carrega memória persistente do projeto
    context = {
      files = {
        ".avante/session.md",
      },
    },

    -- Prompt global pra economizar token e evitar spam
    system_prompt = [[
Regras obrigatórias:
- NÃO reimprimir arquivos completos.
- Mostrar apenas diff ou trechos alterados.
- Não aplicar mudanças automaticamente.
- Pedir contexto extra apenas se indispensável.
- Ser direto, técnico e orientado à execução.
    ]],

    mappings = {
      sidebar = {
        apply_cursor = "a",
        apply_all = "A",
      },
    },

    windows = {
      ask = {
        focus_on_apply = "ours",
      },
    },
  },
}
