-- plugins/mason.lua
return {
  "williamboman/mason.nvim",
  event = "VeryLazy",

  -- 1) Preenche ensure_installed a partir do mason-packages.txt (sem perder o que já existe)
  opts = function(_, opts)
    local cfg_dir = vim.fn.stdpath("config")
    local list_file = cfg_dir .. "/mason-packages.txt"

    -- compat: vim.trim pode não existir em versões antigas
    if not vim.trim then
      vim.trim = function(s)
        return (s:gsub("^%s*(.-)%s*$", "%1"))
      end
    end

    local function read_list()
      local pkgs, seen = {}, {}
      local f = io.open(list_file, "r")
      if not f then
        return pkgs
      end
      for line in f:lines() do
        line = vim.trim(line or "")
        if line ~= "" and not line:match("^#") and not seen[line] then
          seen[line] = true
          table.insert(pkgs, line)
        end
      end
      f:close()
      table.sort(pkgs)
      return pkgs
    end

    local from_file = read_list()
    opts = opts or {}
    opts.ensure_installed = opts.ensure_installed or {}

    -- junta e remove duplicatas
    local dedup, out = {}, {}
    for _, name in ipairs(opts.ensure_installed) do
      if not dedup[name] then
        dedup[name] = true
        table.insert(out, name)
      end
    end
    for _, name in ipairs(from_file) do
      if not dedup[name] then
        dedup[name] = true
        table.insert(out, name)
      end
    end
    opts.ensure_installed = out
    return opts
  end,

  -- 2) Depois do setup do Mason, criamos os comandos e o hook para exportar a lista automaticamente
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require("mason-registry")
    local list_file = vim.fn.stdpath("config") .. "/mason-packages.txt"

    local function write_list(pkgs)
      table.sort(pkgs)
      local f, err = io.open(list_file, "w")
      if not f then
        vim.notify("Erro ao escrever " .. list_file .. ": " .. (err or ""), vim.log.levels.ERROR)
        return false
      end
      for _, name in ipairs(pkgs) do
        f:write(name .. "\n")
      end
      f:close()
      return true
    end

    local function export_installed()
      -- refresh garante estado atualizado após installs
      mr.refresh(function()
        local installed = {}
        for _, pkg in ipairs(mr.get_installed_packages()) do
          table.insert(installed, pkg.name)
        end
        if write_list(installed) then
          vim.notify(("Mason: lista atualizada (%d pacotes)."):format(#installed))
        end
      end)
    end

    -- :MasonExport (manual)
    vim.api.nvim_create_user_command("MasonExport", export_installed, {
      desc = "Exporta pacotes Mason para mason-packages.txt",
    })

    -- :MasonInstallFromFile (manual — instala tudo da lista)
    vim.api.nvim_create_user_command("MasonInstallFromFile", function()
      local lines = {}
      local f = io.open(list_file, "r")
      if f then
        for line in f:lines() do
          line = vim.trim(line)
          if line ~= "" and not line:match("^#") then
            table.insert(lines, line)
          end
        end
        f:close()
      end
      if #lines == 0 then
        vim.notify("Lista vazia ou arquivo não encontrado: " .. list_file, vim.log.levels.WARN)
        return
      end
      vim.cmd("MasonInstall " .. table.concat(lines, " "))
    end, { desc = "Instala pacotes do mason-packages.txt" })

    -- Hook: após qualquer instalação bem-sucedida, exporta automaticamente
    mr:on("package:install:success", function()
      vim.defer_fn(export_installed, 300)
    end)

    -- Extra: ao sair do Neovim, exporta (garantia)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        export_installed()
      end,
    })
  end,
}
