-- plugins/mason.lua
return {
  "mason-org/mason.nvim",
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

    -- COMANDO: :MasonInstallFromFile (apenas pacotes AUSENTES)
    vim.api.nvim_create_user_command("MasonInstallFromFile", function()
      local function read_list(path)
        local lines, f = {}, io.open(list_file or path, "r")
        if not f then
          vim.notify("Lista não encontrada: " .. (list_file or path), vim.log.levels.WARN)
          return {}
        end
        for line in f:lines() do
          line = vim.trim(line)
          if line ~= "" and not line:match("^#") then
            table.insert(lines, line)
          end
        end
        f:close()
        return lines
      end

      local ok_reg, registry = pcall(require, "mason-registry")
      if not ok_reg then
        vim.notify("mason-registry não disponível (carregue o Mason).", vim.log.levels.WARN)
        return
      end

      local wanted = read_list(list_file)
      if #wanted == 0 then
        return
      end

      registry.refresh(function()
        local to_install, unknown = {}, {}
        for _, name in ipairs(wanted) do
          local ok_pkg, pkg = pcall(registry.get_package, name)
          if not ok_pkg then
            table.insert(unknown, name)
          else
            if not pkg:is_installed() then
              table.insert(to_install, name)
            end
          end
        end

        if #unknown > 0 then
          vim.notify(
            "Não encontrados no Mason: " .. table.concat(unknown, ", "),
            vim.log.levels.WARN,
            { title = "Mason" }
          )
        end

        if #to_install == 0 then
          vim.notify("Todos os pacotes da lista já estão instalados ✅", vim.log.levels.INFO, { title = "Mason" })
          return
        end

        vim.notify("Instalando ausentes: " .. table.concat(to_install, " "), vim.log.levels.INFO, { title = "Mason" })
        vim.schedule(function()
          vim.cmd("MasonInstall " .. table.concat(to_install, " "))
        end)
      end)
    end, { desc = "Instala apenas pacotes ausentes do mason-packages.txt" })

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
