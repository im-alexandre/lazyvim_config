return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    -- 1. CONFIGURAÇÃO DO PICKER (EXPANSÃO)
    -- Ao declarar a estrutura assim, o Lazy faz o merge com os defaults.
    picker = {
      win = {
        input = {
          keys = {
            -- Adiciona APENAS este mapping, mantendo os originais (<CR>, <Esc>, etc)
            ["<c-s>"] = { "edit_vsplit", mode = { "i", "n" } },
          },
        },
        -- Se quiser garantir também na lista de resultados (navegação normal)
        list = {
          keys = {
            ["<c-s>"] = { "edit_vsplit", mode = { "i", "n" } },
          },
        },
      },
    },

    -- 2. SEU DASHBOARD (MANTIDO INTACTO)
    dashboard = {
      preset = {
        pick = function(cmd, opts)
          return LazyVim.pick(cmd, opts)()
        end,
        header = [[
                ██╗  ██╗ █████╗ ███╗   ██╗██████╗  █████╗  ██████╗      █╗      █████╗ ██████╗ ███████╗
                ╚██╗██╔╝██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔═══██╗     █║     ██╔══██╗██╔══██╗██╔════╝
                 ╚███╔╝ ███████║██╔██╗ ██║██║  ██║███████║██║   ██║████ █║     ███████║██████╔╝███████╗
                 ██╔██╗ ██╔══██║██║╚██╗██║██║  ██║██╔══██║██║   ██║     █║     ██╔══██║██╔══██╗╚════██║
                ██╔╝ ██╗██║  ██║██║ ╚████║██████╔╝██║  ██║╚██████╔╝     ██████╗██║  ██║██████╔╝███████║
                ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝      ══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝
              ]],

        finder = {
          cmd = "fd",
          args = {
            "--type",
            "f",
            "--hidden",
            "--exclude",
            ".git",
            "--ignore-file",
            ".gitignore",
          },
        },
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Close Dashboard", action = function ()
            pcall(vim.api.nvim_buf_delete, 0, { force = false })
            vim.cmd(":lua Snacks.explorer()")
          end
          },
        },
      },
    },
  },
}
