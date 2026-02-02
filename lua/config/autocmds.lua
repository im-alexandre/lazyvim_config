-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Auto update da config do LazyVim
-- AUTOCMD: Git pull no config; se atualizou, roda :MasonInstallFromFile

vim.api.nvim_create_autocmd("User", {
  pattern = "AvanteReady",
  callback = function()
    vim.cmd("AvanteSwitchProvider claude")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "[stdin]" },
  callback = function()
    vim.bo.filetype = "diff"
    vim.opt.foldmethod = "diff"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.j2", "*.jinja2", "*.jinja" },
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})
vim.api.nvim_command('command! CiQuote execute "normal ci" | :stopinsert"')

-- Comando manual para atualizar a config via git pull e instalar Mason ausentes
vim.api.nvim_create_user_command("ConfigUpdate", function()
  local config_path = vim.fn.stdpath("config")
  local out = {}
  local cmd = { "git", "-C", config_path, "pull", "--ff-only" }
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        for _, l in ipairs(data) do
          if l ~= "" then
            table.insert(out, l)
          end
        end
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = "LazyVim Git Pull" })
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.ERROR, { title = "LazyVim Git Pull" })
      end
    end,
    on_exit = function(_, code)
      local stdout = table.concat(out, "\n")
      local updated = (code == 0)
        and not stdout:match("[Aa]lready up%-to%-date")
        and not stdout:match("[Aa]lready up to date")
      if stdout:match("[Ff]ast%-forward") or stdout:match("[Uu]pdating%s+[%w]+%.+[%w]+") then
        updated = true
      end
      if updated then
        vim.schedule(function()
          vim.cmd("MasonInstallFromFile")
        end)
      end
    end,
  })
end, { desc = "Atualiza config via git pull e instala Mason ausentes" })

-- Inicia JDTLS somente ao abrir arquivo Java
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    pcall(function()
      require("lazy").load({ plugins = { "nvim-jdtls" } })
    end)
    local ok, jdtls_cfg = pcall(require, "config.jdtls")
    if not ok then
      vim.notify("JDTLS config não carregou (plugin ausente?)", vim.log.levels.WARN)
      return
    end
    local ok_setup, err = pcall(jdtls_cfg.setup_jdtls)
    if not ok_setup and err then
      vim.notify("Falha ao iniciar JDTLS: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})

-- Função para garantir que o dicionário PT-BR exista
local function ensure_pt_spell()
  -- 1. Define os caminhos e URLs
  local spell_dir = vim.fn.stdpath("data") .. "/site/spell"
  local spl_url = "http://ftp.vim.org/vim/runtime/spell/pt.utf-8.spl"
  local sug_url = "http://ftp.vim.org/vim/runtime/spell/pt.utf-8.sug"
  local spl_dest = spell_dir .. "/pt.utf-8.spl"
  local sug_dest = spell_dir .. "/pt.utf-8.sug"

  -- 2. Verifica se o arquivo principal já existe
  if vim.fn.filereadable(spl_dest) == 1 then
    return -- Já está instalado, não faz nada
  end

  -- 3. Notifica o usuário que o download vai começar
  vim.notify(
    "Dicionário PT-BR não encontrado.\nBaixando arquivos de spellcheck...",
    vim.log.levels.INFO,
    { title = "Configuração Automática" }
  )

  -- 4. Cria a estrutura de pastas (mkdir -p)
  vim.fn.mkdir(spell_dir, "p")

  -- 5. Função auxiliar para baixar usando curl
  local function download(url, dest)
    -- O comando curl -fLo baixa seguindo redirects e falha silenciosamente se der erro 404
    -- shellescape garante que funcione mesmo se o caminho tiver espaços no Windows
    local cmd = string.format("curl -fLo %s %s", vim.fn.shellescape(dest), vim.fn.shellescape(url))

    local result = vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify("Falha ao baixar: " .. url, vim.log.levels.ERROR)
      return false
    end
    return true
  end

  -- 6. Executa os downloads
  local success_spl = download(spl_url, spl_dest)
  local success_sug = download(sug_url, sug_dest)

  if success_spl then
    vim.notify(
      "Dicionário PT-BR instalado com sucesso!\nReinicie o Neovim ou digite :mkspell",
      vim.log.levels.INFO,
      { title = "Sucesso" }
    )

    -- Força o recarregamento do spellcheck no buffer atual
    vim.schedule(function()
      vim.opt.spell = true
      vim.opt.spelllang = { "en", "pt" } -- Usa 'pt' pois o arquivo é pt.utf-8.spl
    end)
  end
end

-- Executa a verificação na inicialização
ensure_pt_spell()
