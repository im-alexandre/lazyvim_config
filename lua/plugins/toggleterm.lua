CMD = [[wsl /mnt/c/Users/imale/AppData/Roaming/npm/codex]]
return {
  "akinsho/toggleterm.nvim",
  version = "*",

  config = function()
    require("toggleterm").setup({
      direction = "float",
      float_opts = { border = "rounded" },
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local codex = Terminal:new({
      cmd = CMD,
      hidden = false,
      direction = "float",
      on_open = function(term)
        vim.cmd("startinsert")
      end,
    })

    vim.api.nvim_create_user_command("Codex", function()
      codex:toggle()
    end, { desc = "Open Codex in toggle terminal" })

    vim.keymap.set("n", "<leader>cx", function()
      codex:toggle()
    end, { noremap = true, silent = true, desc = "Toggle Codex" })
  end,
}
