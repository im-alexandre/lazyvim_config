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
          { icon = " ", key = "f", desc = "Encontrar arquivo", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "Novo Arquivo", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Pesquisa Textual", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Arquivos Recentes", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "c", desc = "Configurações", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restaurar última sessão", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = "󰚩 ", key = "a", desc = "Avante Ask", action = ":AvanteAsk" },
          {
            icon = " ",
            key = "p",
            desc = "Escolher Projeto (D:/desenvolvimento_local)",
            action = function()
              local root = "D:/desenvolvimento_local"

              -- Get directories in the root path
              local handle = vim.loop.fs_scandir(root)
              if not handle then
                vim.notify("Não foi possível listar " .. root, vim.log.levels.ERROR, { title = "Projeto" })
                return
              end

              local projects = {}
              while true do
                local name, t = vim.loop.fs_scandir_next(handle)
                if not name then
                  break
                end
                if t == "directory" then
                  table.insert(projects, name)
                end
              end

              if vim.tbl_isempty(projects) then
                vim.notify("Nenhum diretório encontrado em " .. root, vim.log.levels.WARN, { title = "Projeto" })
                return
              end

              table.sort(projects)

              vim.ui.select(projects, {
                prompt = "Escolha um projeto em D:/desenvolvimento_local",
              }, function(choice)
                if not choice then
                  return
                end

                local target = root .. "/" .. choice

                -- Change the current working directory globally
                vim.fn.chdir(target)

                -- Optional: notify the user
                vim.notify("Diretório alterado para: " .. target, vim.log.levels.INFO, {
                  title = "Projeto selecionado",
                })

              vim.cmd(":lua Snacks.explorer()")
              end)
            end,
          },
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
