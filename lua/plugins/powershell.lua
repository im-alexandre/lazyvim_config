local bundle_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services")
local shell = vim.fn.executable("pwsh.exe") == 1 and "pwsh.exe" or "pwsh"
local script_path = vim.fs.normalize(bundle_path .. "/PowerShellEditorServices/Start-EditorServices.ps1")
local cache_path = vim.fs.normalize(vim.fn.stdpath("cache"))

local function powershell_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  if LazyVim.has("blink.cmp") then
    return require("blink.cmp").get_lsp_capabilities(capabilities)
  end

  return capabilities
end

local function sanitize_powershell_text(value)
  if type(value) ~= "string" then
    return value
  end

  value = value:gsub("\r", "")
  value = value:gsub("^\n+", "")
  value = value:gsub("\n+$", "")
  return value
end

local function sanitize_powershell_items(_, items)
  local sanitized = {}
  local seen = {}

  for _, item in ipairs(items) do
    item.label = sanitize_powershell_text(item.label)
    item.filterText = sanitize_powershell_text(item.filterText)
    item.insertText = sanitize_powershell_text(item.insertText)
    item.detail = sanitize_powershell_text(item.detail)

    if type(item.documentation) == "string" then
      item.documentation = sanitize_powershell_text(item.documentation)
    elseif type(item.documentation) == "table" then
      item.documentation.value = sanitize_powershell_text(item.documentation.value)
    end

    local key = table.concat({
      item.label or "",
      item.insertText or "",
      item.detail or "",
      item.kind or "",
    }, "\x1f")

    if not seen[key] then
      seen[key] = true
      sanitized[#sanitized + 1] = item
    end
  end

  return sanitized
end

return {
  {
    "Saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.per_filetype = opts.sources.per_filetype or {}

      local lsp_provider = vim.deepcopy(opts.sources.providers.lsp or {})
      lsp_provider.module = lsp_provider.module or "blink.cmp.sources.lsp"
      lsp_provider.name = lsp_provider.name or "LSP"
      lsp_provider.fallbacks = {}
      lsp_provider.transform_items = sanitize_powershell_items
      opts.sources.providers.powershell_lsp = lsp_provider

      opts.sources.per_filetype.ps1 = { "powershell_lsp", "path", "snippets" }
      opts.sources.per_filetype.psm1 = { "powershell_lsp", "path", "snippets" }
      opts.sources.per_filetype.psd1 = { "powershell_lsp", "path", "snippets" }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        powershell_es = {
          bundle_path = bundle_path,
          shell = shell,
          cmd = function(dispatchers)
            local nonce = tostring(vim.uv.hrtime())
            local session_path = vim.fs.normalize(cache_path .. "/powershell_es_" .. nonce .. ".session.json")
            local log_path = vim.fs.normalize(cache_path .. "/powershell_es_" .. nonce .. ".log")
            local cmd = {
              shell,
              "-NoLogo",
              "-NoProfile",
              "-NonInteractive",
              "-ExecutionPolicy",
              "Bypass",
              "-File",
              script_path,
              "-HostName",
              "nvim",
              "-HostProfileId",
              "Neovim",
              "-HostVersion",
              "1.0.0",
              "-LogPath",
              log_path,
              "-LogLevel",
              "Warning",
              "-BundledModulesPath",
              bundle_path,
              "-LanguageServiceOnly",
              "-SessionDetailsPath",
              session_path,
            }

            local jobid = vim.fn.jobstart(cmd)
            if jobid <= 0 then
              vim.notify("Falha ao iniciar PowerShell Editor Services.", vim.log.levels.ERROR)
              return vim.lsp.rpc.start({ shell, "-NoLogo", "-NoProfile", "-Command", "exit 1" }, dispatchers)
            end

            local ok = vim.wait(15000, function()
              return vim.fn.filereadable(session_path) == 1
            end, 100)

            if not ok then
              pcall(vim.fn.jobstop, jobid)
              vim.notify("PowerShell Editor Services nao criou o arquivo de sessao a tempo.", vim.log.levels.ERROR)
              return vim.lsp.rpc.start({ shell, "-NoLogo", "-NoProfile", "-Command", "exit 1" }, dispatchers)
            end

            local lines = vim.fn.readfile(session_path)
            pcall(vim.fn.delete, session_path)

            local ok_json, session = pcall(vim.json.decode, table.concat(lines, "\n"))
            if not ok_json or not session or not session.languageServicePipeName then
              pcall(vim.fn.jobstop, jobid)
              vim.notify("PowerShell Editor Services nao retornou um pipe valido.", vim.log.levels.ERROR)
              return vim.lsp.rpc.start({ shell, "-NoLogo", "-NoProfile", "-Command", "exit 1" }, dispatchers)
            end

            local connector = vim.lsp.rpc.connect(session.languageServicePipeName)
            local public_client = connector(dispatchers)
            local terminate = public_client.terminate

            public_client.terminate = function(...)
              pcall(terminate, ...)
              pcall(vim.fn.jobstop, jobid)
            end

            return public_client
          end,
          capabilities = powershell_capabilities(),
          single_file_support = true,
          filetypes = { "ps1", "psm1", "psd1" },
          root_dir = function(bufnr, on_dir)
            local path = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fs.root(path, { "PSScriptAnalyzerSettings.psd1", ".git" })
            on_dir(root or vim.fs.dirname(path))
          end,
          settings = {
            powershell = {
              enableProfileLoading = false,
              scriptAnalysis = {
                enable = true,
              },
              codeFormatting = {
                pipelineIndentationStyle = "IncreaseIndentationForFirstPipeline",
                preset = "OTBS",
              },
            },
          },
        },
      },
    },
  },
}
