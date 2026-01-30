-- lua/plugins/mini-icons.lua (ou override no seu spec)
return {
  "nvim-mini/mini.icons",
  opts = function(_, opts)
    local M = require("mini.icons")
    -- pega ícone e highlight já usados para a extensão 'html'
    local glyph, hl = M.get("extension", "jinja") -- retorna (icon, hl, is_default) :contentReference[oaicite:1]{index=1}

    opts = opts or {}
    opts.extension = vim.tbl_deep_extend("force", opts.extension or {}, {
      jinja = { glyph = glyph, hl = hl },
      jinja2 = { glyph = glyph, hl = hl },
      j2 = { glyph = glyph, hl = hl },
    })
    opts.filetype = vim.tbl_deep_extend("force", opts.filetype or {}, {
      htmldjango = { glyph = glyph, hl = hl },
    })

    return opts -- LazyVim chamará MiniIcons.setup(opts) pra você :contentReference[oaicite:2]{index=2}
  end,
}
