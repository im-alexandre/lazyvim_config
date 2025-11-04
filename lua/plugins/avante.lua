vim.env["AVANTE_OPENAI_API_KEY"] = vim.fn.readfile(vim.fn.stdpath("config") .. "/.open_api_key")[1]
return {
  "yetone/avante.nvim",
  -- Compilação/instalação (Windows usa PowerShell; Linux/macOS usa make)
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false, -- manter sempre atualizado
  opts = {
    -- Instruções por projeto: o Avante vai ler este arquivo no root do repo atual
    instructions_file = "avante.md",

    -- Provider e modelo (ajuste conforme seu plano)
    provider = "openai",
    providers = {
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-5", -- troque para o modelo de sua preferência
        timeout = 30000, -- em ms
        extra_request_body = {
          temperature = 0,
          -- max_completion_tokens = 8192,
        },
        -- A chave é lida de: ENV["OPENAI_API_KEY"]
      },
    },

    -- Se quiser um comportamento menos "agente", descomente:
    -- mode = "legacy",
  },

  config = function(_, opts)
    -- Shell mais leve no Windows (usa cmd.exe em vez de pwsh)
    if vim.loop.os_uname().sysname == "Windows_NT" then
      vim.opt.shell = "cmd.exe"
      vim.opt.shellcmdflag = "/s /c"
      vim.opt.shellquote = ""
      vim.opt.shellxquote = ""
    end

    local avante = require("avante")
    avante.setup(opts)

    -- Mapeamentos úteis
    -- Novo chat no MESMO projeto (mantém histórico anterior acessível em :AvanteHistory)
    vim.keymap.set("n", "<leader>aN", "<cmd>AvanteChatNew<cr>", { desc = "Avante: Novo chat" })
    -- Abrir histórico de chats (por projeto)
    vim.keymap.set("n", "<leader>aH", "<cmd>AvanteHistory<cr>", { desc = "Avante: Histórico" })
    -- Limpar apenas a conversa atual (não apaga históricos antigos)
    vim.keymap.set("n", "<leader>aC", "<cmd>AvanteClear session<cr>", { desc = "Avante: Limpar sessão atual" })
    -- Limpar caches/históricos de TODOS os projetos (use com cuidado)
    vim.keymap.set("n", "<leader>aX", "<cmd>AvanteClear cache<cr>", { desc = "Avante: Limpar cache global" })

    -- 🔒 Por-projeto: não resetar automaticamente ao abrir o Neovim.
    -- O Avante detecta o arquivo 'avante.md' no CWD e mantém um histórico por diretório.
    -- Se quiser sempre iniciar focado no chat atual do projeto, você pode focar a janela do Avante:
    -- vim.api.nvim_create_autocmd("VimEnter", {
    --   callback = function()
    --     if vim.fn.exists(":AvanteFocus") == 2 then
    --       vim.cmd("silent! AvanteFocus")
    --     end
    --   end,
    -- })
  end,
}
