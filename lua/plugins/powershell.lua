local bundle_path = vim.fs.normalize(vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services")
local shell = vim.fn.executable("pwsh.exe") == 1 and "pwsh.exe" or "pwsh"
local cache_path = vim.fs.normalize(vim.fn.stdpath("cache"))
local command = ([[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Warning]]):format(
  bundle_path,
  bundle_path,
  cache_path,
  cache_path
)

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        powershell_es = {
          bundle_path = bundle_path,
          shell = shell,
          cmd = { shell, "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", command },
          single_file_support = true,
          filetypes = { "ps1" },
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
