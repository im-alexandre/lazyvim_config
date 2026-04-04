-- :JupyniumLaunch [dir]
-- 1. Abre terminal Snacks rodando `jupyter nbclassic` (visível para ver o token)
-- 2. Aguarda o servidor responder via curl
-- 3. Inicia o processo jupynium Python sem --jupyter_command (não sobe outro jupyter)
--    e conecta ao endereço de servidor deste Neovim

local NB_URL = "localhost:8888/nbclassic"
local POLL_DELAY_MS = 2000  -- espera inicial antes de começar a verificar
local POLL_INTERVAL_MS = 1000
local MAX_RETRIES = 25

local function start_jupynium_daemon(notebook_url)
  local nvim_addr = vim.v.servername
  if not nvim_addr or nvim_addr == "" then
    vim.notify("JupyniumLaunch: não foi possível obter vim.v.servername.", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({
    "python",
    "-m", "jupynium",
    "--notebook_URL", notebook_url,
    "--nvim_listen_addr", nvim_addr,
    -- sem --jupyter_command: jupynium não tenta iniciar outro jupyter
  }, {
    detach = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("Jupynium encerrou com código " .. code, vim.log.levels.WARN)
        end)
      end
    end,
  })

  vim.notify("Jupynium iniciado. Conectando ao notebook...", vim.log.levels.INFO)
end

local function poll_server(notebook_url, retries)
  if retries <= 0 then
    vim.notify("JupyniumLaunch: nbclassic não respondeu a tempo.", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart(
    { "curl", "-s", "-o", "/dev/null", "-w", "%{http_code}", "http://" .. notebook_url },
    {
      stdout_buffered = true,
      on_stdout = function(_, data)
        local code = table.concat(data or {}, ""):gsub("%s+", "")
        if code:match("^[23]") then
          vim.schedule(function()
            start_jupynium_daemon(notebook_url)
          end)
        else
          vim.defer_fn(function()
            poll_server(notebook_url, retries - 1)
          end, POLL_INTERVAL_MS)
        end
      end,
      on_exit = function(_, exit_code)
        if exit_code ~= 0 then
          vim.defer_fn(function()
            poll_server(notebook_url, retries - 1)
          end, POLL_INTERVAL_MS)
        end
      end,
    }
  )
end

vim.api.nvim_create_user_command("JupyniumLaunch", function(opts)
  local notebook_dir = (opts.args ~= "") and opts.args or vim.fn.getcwd()

  -- 1. Abre nbclassic num terminal Snacks (bottom split)
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.terminal then
    snacks.terminal(
      "jupyter nbclassic --no-browser --notebook-dir=" .. vim.fn.shellescape(notebook_dir),
      { win = { position = "bottom", height = 0.30 } }
    )
  else
    vim.fn.jobstart(
      { "jupyter", "nbclassic", "--no-browser", "--notebook-dir=" .. notebook_dir },
      { detach = true }
    )
  end

  vim.notify("Aguardando nbclassic iniciar em " .. NB_URL .. " ...", vim.log.levels.INFO)

  -- 2. Começa polling após delay inicial (servidor precisa de alguns segundos)
  vim.defer_fn(function()
    poll_server(NB_URL, MAX_RETRIES)
  end, POLL_DELAY_MS)
end, {
  nargs = "?",
  complete = "dir",
  desc = "Inicia nbclassic + Jupynium e faz attach neste Neovim",
})