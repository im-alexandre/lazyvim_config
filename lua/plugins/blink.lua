return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = opts.completion or {}
    opts.completion.list = opts.completion.list or {}
    opts.completion.list.selection = opts.completion.list.selection or {}

    -- Nunca pré-seleciona o primeiro item do autocomplete.
    opts.completion.list.selection.preselect = false

    return opts
  end,
}
