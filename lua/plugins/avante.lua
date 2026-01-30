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
    -- Sem modo agentic (sem ferramentas).
    mode = "legacy",
    provider = "openai",

    providers = {
      openai = {
        model = "gpt-4o",
        api_key_name = "OPENAI_API_KEY",
        disable_tools = true,
        model_names = {
          "gpt-4o",
          "gpt-4o-mini",
        },
      },
    },

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
