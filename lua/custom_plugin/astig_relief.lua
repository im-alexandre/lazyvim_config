local M = {}

-- ===============  CONFIG CONFORTO VISUAL =====================--

local on = {
  -- Fonte maior (só tem efeito em GUI)
  guifont = "FiraCode Nerd Font:h24",

  -- Melhor leitura
  number = true,
  relativenumber = false,
  cursorline = true,
  scrolloff = 8,
  sidescrolloff = 8,

  -- Cores adaptadas (Gruvbox sólido)
  colorscheme = function()
    pcall(function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = false,
        overrides = {
          Normal = { bg = "#1D1D1D" },
          NormalFloat = { bg = "#1D1D1D" },
          SignColumn = { bg = "#1D1D1D" },
          LineNr = { fg = "#7A7A7A" },
          CursorLineNr = { fg = "#FFFFFF", bold = true },
        },
      })
      vim.cmd("colorscheme gruvbox")
    end)
  end,
}

local off = {
  guifont = nil,
  linespace = 0,
  relativenumber = true,
  cursorline = false,
}

-- =============  APLICAÇÃO =====================================--

function M.apply(tbl)
  for opt, val in pairs(tbl) do
    if opt == "colorscheme" then
      val()
    else
      vim.opt[opt] = val
    end
  end
end

function M.on()
  M.apply(on)
  vim.notify("🔆 Astig Relief Mode ATIVADO (XANDAO MODE)", vim.log.levels.INFO)
end

function M.off()
  M.apply(off)
  vim.cmd("colorscheme gruvbox") -- restaura (opcional)
  vim.notify("🌑 Astig Relief Mode DESATIVADO", vim.log.levels.WARN)
end

-- =====================================
-- REGISTRA COMANDOS NEOVIM DIRETO
-- =====================================

vim.api.nvim_create_user_command("AstigOn", M.on, {})
vim.api.nvim_create_user_command("AstigOff", M.off, {})

return M
