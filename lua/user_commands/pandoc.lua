local has_telescope, builtin = pcall(require, "telescope.builtin")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function run_pandoc_conversion(filepath)
  if not filepath or filepath == "" then
    return
  end

  local abs_path = vim.fn.fnamemodify(filepath, ":p")
  local current_ext = vim.fn.fnamemodify(abs_path, ":e")
  local file_root = vim.fn.fnamemodify(abs_path, ":r")

  local input_formats = { "markdown", "gfm", "html", "docx", "latex", "json" }
  local output_formats = { "docx", "pdf", "html", "markdown", "pptx" }

  vim.ui.select(input_formats, {
    prompt = "in 📥 Formato de origem (Detectado: " .. current_ext .. "):",
    default = current_ext,
  }, function(input_fmt)
    if not input_fmt then
      return
    end

    vim.ui.select(output_formats, {
      prompt = "out 📤 Formato de destino:",
    }, function(output_fmt)
      if not output_fmt then
        return
      end

      local output_file = file_root .. "." .. output_fmt

      -- CONFIGURAÇÃO DA ENGINE DE PDF
      local extra_args = ""
      if output_fmt == "pdf" then
        -- wkhtmltopdf é mais estável que o Tectonic pois é offline
        extra_args = "--pdf-engine=wkhtmltopdf"

        -- Dica: Se quiser margens melhores com wkhtmltopdf:
        -- extra_args = "--pdf-engine=wkhtmltopdf -V margin-top=2cm -V margin-bottom=2cm"
      end

      vim.notify("⚙️ Convertendo...", vim.log.levels.INFO)

      local cmd =
        string.format('pandoc "%s" -f %s -t %s %s -o "%s"', abs_path, input_fmt, output_fmt, extra_args, output_file)

      local output = vim.fn.system(cmd)

      if vim.v.shell_error == 0 then
        vim.notify("✅ Sucesso! Arquivo gerado:\n" .. output_file, vim.log.levels.INFO)
      else
        vim.notify("❌ Erro na conversão:\n" .. output, vim.log.levels.ERROR)
      end
    end)
  end)
end

vim.api.nvim_create_user_command("PandocTelescope", function()
  if vim.fn.executable("pandoc") ~= 1 then
    vim.notify("❌ Erro: 'pandoc' não encontrado.", vim.log.levels.ERROR)
    return
  end

  if not has_telescope then
    vim.notify("❌ Erro: Telescope não encontrado.", vim.log.levels.ERROR)
    return
  end

  builtin.find_files({
    prompt_title = "🔍 Pandoc: Selecione arquivo",
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          run_pandoc_conversion(selection[1] or selection.path)
        end
      end)
      return true
    end,
  })
end, { desc = "Converte arquivos com Pandoc + Telescope" })
