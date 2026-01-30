local INPUT_FORMATS = { "markdown", "gfm", "html", "docx", "latex", "json" }
local OUTPUT_FORMATS = { "docx", "pdf", "html", "markdown", "pptx" }

local DEFAULT_PDF_ENGINE = "wkhtmltopdf"

local function notify_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function notify_info(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

local function list_to_set(list)
  local set = {}
  for _, v in ipairs(list) do
    set[v] = true
  end
  return set
end

local INPUT_FORMATS_SET = list_to_set(INPUT_FORMATS)

local function ensure_executable(cmd)
  if vim.fn.executable(cmd) ~= 1 then
    notify_err("❌ Erro: '" .. cmd .. "' não encontrado.")
    return false
  end
  return true
end

local EXTENSION_TO_PANDOC_FORMAT = {
  md = "markdown",
  markdown = "markdown",
  mkd = "markdown",
  mdown = "markdown",
  gfm = "gfm",
  html = "html",
  htm = "html",
  tex = "latex",
  latex = "latex",
  docx = "docx",
  json = "json",
}

local function extension_to_pandoc_format(ext)
  ext = (ext or ""):lower()
  return EXTENSION_TO_PANDOC_FORMAT[ext] or ext
end

local function load_telescope()
  local ok_builtin, builtin = pcall(require, "telescope.builtin")
  if not ok_builtin then
    return nil
  end

  local ok_actions, actions = pcall(require, "telescope.actions")
  if not ok_actions then
    return nil
  end

  local ok_action_state, action_state = pcall(require, "telescope.actions.state")
  if not ok_action_state then
    return nil
  end

  return {
    builtin = builtin,
    actions = actions,
    action_state = action_state,
  }
end

local function telescope_entry_path(selection)
  if type(selection) ~= "table" then
    return nil
  end

  -- Different Telescope pickers expose the selected path differently.
  return selection.path or selection.filename or selection.value or selection[1]
end

local function build_pandoc_args(abs_path, input_fmt, output_fmt, output_file)
  local args = {
    abs_path,
    "-f",
    input_fmt,
    "-t",
    output_fmt,
    "-o",
    output_file,
  }

  if output_fmt == "pdf" then
    table.insert(args, "--pdf-engine=" .. DEFAULT_PDF_ENGINE)

    -- Tip: If you want better margins with wkhtmltopdf:
    -- table.insert(args, "-V")
    -- table.insert(args, "margin-top=2cm")
    -- table.insert(args, "-V")
    -- table.insert(args, "margin-bottom=2cm")
  end

  return args
end

local function run_system(cmd, args, on_exit)
  local argv = { cmd }
  for _, a in ipairs(args or {}) do
    table.insert(argv, a)
  end

  if vim.system then
    vim.system(argv, { text = true }, function(res)
      local code = (res and res.code) or 1
      local stdout = (res and res.stdout) or ""
      local stderr = (res and res.stderr) or ""
      on_exit(code, stdout, stderr)
    end)
    return
  end

  -- Fallback for older Neovim versions: vim.fn.system() accepts argv lists.
  local output = vim.fn.system(argv)
  on_exit(vim.v.shell_error, output or "", "")
end

local function run_pandoc_conversion(filepath)
  if not filepath or filepath == "" then
    return
  end

  if not ensure_executable("pandoc") then
    return
  end

  local abs_path = vim.fn.fnamemodify(filepath, ":p")
  local current_ext = vim.fn.fnamemodify(abs_path, ":e")
  local file_root = vim.fn.fnamemodify(abs_path, ":r")

  local detected_ext = current_ext ~= "" and current_ext or "sem extensão"

  local default_input = extension_to_pandoc_format(current_ext)
  if not INPUT_FORMATS_SET[default_input] then
    default_input = nil
  end

  vim.ui.select(INPUT_FORMATS, {
    prompt = "in 📥 Formato de origem (Detectado: " .. detected_ext .. "):",
    default = default_input,
  }, function(input_fmt)
    if not input_fmt then
      return
    end

    vim.ui.select(OUTPUT_FORMATS, {
      prompt = "out 📤 Formato de destino:",
    }, function(output_fmt)
      if not output_fmt then
        return
      end

      local output_file = file_root .. "." .. output_fmt
      local args = build_pandoc_args(abs_path, input_fmt, output_fmt, output_file)

      notify_info("⚙️ Convertendo...")

      run_system("pandoc", args, function(code, stdout, stderr)
        if code == 0 then
          notify_info("✅ Sucesso! Arquivo gerado:\n" .. output_file)
          return
        end

        local details = stderr
        if details == "" then
          details = stdout
        end

        notify_err("❌ Erro na conversão:\n" .. details)
      end)
    end)
  end)
end

vim.api.nvim_create_user_command("PandocTelescope", function()
  if not ensure_executable("pandoc") then
    return
  end

  local telescope = load_telescope()
  if not telescope then
    notify_err("❌ Erro: Telescope não encontrado.")
    return
  end

  telescope.builtin.find_files({
    prompt_title = "🔍 Pandoc: Selecione arquivo",
    attach_mappings = function(prompt_bufnr)
      telescope.actions.select_default:replace(function()
        telescope.actions.close(prompt_bufnr)

        local selection = telescope.action_state.get_selected_entry()
        local path = telescope_entry_path(selection)
        if not path or path == "" then
          notify_err("❌ Erro: não foi possível obter o caminho do arquivo selecionado.")
          return
        end

        run_pandoc_conversion(path)
      end)

      return true
    end,
  })
end, { desc = "Converte arquivos com Pandoc + Telescope" })
