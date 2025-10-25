-- plugins/mason-export.lua
return {
  "williamboman/mason.nvim",
  config = function()
    local mason_registry = require("mason-registry")
    local LIST_PATH = vim.fn.stdpath("config") .. "/mason-packages.txt"

    -- Funções utilitárias ----------------------------

    local function write_list(pkgs)
      table.sort(pkgs)
      local f, err = io.open(LIST_PATH, "w")
      if not f then
        vim.notify("Erro ao escrever " .. LIST_PATH .. ": " .. (err or ""), vim.log.levels.ERROR)
        return false
      end
      for _, name in ipairs(pkgs) do
        f:write(name .. "\n")
      end
      f:close()
      return true
    end

    local function export_installed()
      mason_registry.refresh(function()
        local installed = {}
        for _, pkg in ipairs(mason_registry.get_installed_packages()) do
          table.insert(installed, pkg.name)
        end
        if write_list(installed) then
          vim.notify("Lista Mason atualizada com " .. #installed .. " pacotes.")
        end
      end)
    end

    local function read_list()
      local pkgs = {}
      local f = io.open(LIST_PATH, "r")
      if not f then return pkgs end
      for line in f:lines() do
        line = vim.trim(line)
        if line ~= "" and not line:match("^#") then
          table.insert(pkgs, line)
        end
      end
      f:close()
      return pkgs
    end

    ---------------------------------------------------

    -- Comando manual: exportar lista
    vim.api.nvim_create_user_command("MasonExport", export_installed, {
      desc = "Exporta pacotes Mason instalados para mason-packages.txt",
    })

    -- Comando manual: instalar lista
    vim.api.nvim_create_user_command("MasonInstallFromFile", function()
      local list = read_list()
      if #list == 0 then
        vim.notify("Nenhum pacote listado em " .. LIST_PATH, vim.log.levels.WARN)
        return
      end
      vim.cmd("MasonInstall " .. table.concat(list, " "))
    end, {
      desc = "Instala pacotes listados no mason-packages.txt",
    })

    -- ⚡ Atualiza automaticamente sempre que algo novo for instalado
    mason_registry:on("package:install:success", function()
      vim.defer_fn(export_installed, 500)
    end)

    -- Também atualiza quando o Neovim é fechado (garantia extra)
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function() export_installed() end,
    })
  end,
}
