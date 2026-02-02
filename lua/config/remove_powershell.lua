-- init.lua
if true then
  return
end

local fn, uv = vim.fn, vim.loop

-- Caminhos
local plugin_dir = fn.stdpath("data") .. "/lazy/friendly-snippets"
local ps_file = plugin_dir .. "/snippets/PowerShell.json"

-- Runner de git simples
local function git(args)
  -- usa git -C <dir> para operar dentro do repo do plugin
  fn.system(vim.list_extend({ "git", "-C", plugin_dir }, args))
  return vim.v.shell_error == 0
end

-- Remove o arquivo e registra a remoção (commit; fallback: stash)
local function remove_and_record()
  -- plugin ainda não existe? sai
  if not uv.fs_stat(plugin_dir) then
    return
  end

  -- se o arquivo existir, remove
  if uv.fs_stat(ps_file) then
    local ok_unlink, err = uv.fs_unlink(ps_file)
    if not ok_unlink then
      vim.notify("Falha ao remover PowerShell.json: " .. tostring(err), vim.log.levels.WARN)
      return
    end
  else
    -- já removido anteriormente; ainda assim tente registrar (caso update/checkout recriou índices)
  end

  -- tenta COMMITAR a remoção (com user local só pra esse commit)
  -- 1) git add -A (marca a deleção)
  if not git({ "add", "-A" }) then
    vim.notify("git add falhou em friendly-snippets", vim.log.levels.WARN)
    return
  end

  -- 2) commit (se não houver mudança, commit retorna erro — trataremos)
  local committed = git({
    "-c",
    "user.name=local-friendly-snippets",
    "-c",
    "user.email=local@example.invalid",
    "commit",
    "-m",
    "remove PowerShell.json (local override)",
  })

  if committed then
    vim.notify("PowerShell.json removido e COMMIT feito em friendly-snippets", vim.log.levels.INFO)
    return
  end

  -- 3) fallback: STASH (só se houver algo a stashar)
  --    stasha apenas o caminho alvo; se nada a stashar, ignore
  local stashed =
    git({ "stash", "push", "-m", "remove PowerShell.json (local override)", "--", "snippets/PowerShell.json" })
  if stashed then
    vim.notify("PowerShell.json removido e mudanças STASHadas em friendly-snippets", vim.log.levels.INFO)
  else
    -- Pode não haver mudanças (sem erro real). Silencie.
    -- Único caso problemático seria repo sem git (zip), o que o lazy.nvim não usa por padrão.
  end
end

-- 1) Tenta na inicialização (caso o plugin já esteja presente)
remove_and_record()

-- 2) Repete sempre que o Lazy terminar uma sync/instalação
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  callback = function()
    -- pequena espera opcional para evitar corrida de IO
    vim.defer_fn(remove_and_record, 50)
  end,
})
