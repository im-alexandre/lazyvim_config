local function resolve_python_host()
  local conda_python = os.getenv("CONDA_PYTHON_EXE")
  if conda_python and #conda_python > 0 then
    return conda_python
  end

  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix and #conda_prefix > 0 then
    return conda_prefix:gsub("\\", "/") .. "/python.exe"
  end

  local conda_exe = os.getenv("CONDA_EXE")
  if conda_exe and #conda_exe > 0 then
    return conda_exe:gsub("\\", "/"):gsub("/Scripts/conda.exe", "/python.exe")
  end

  return "D:/tools/anaconda3/python.exe" -- fallback pro seu base
end

local python_configured = false
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    if python_configured then
      return
    end
    python_configured = true
    PYTHON_HOST = resolve_python_host()

    -- Configura pyright para usar o Python do Conda
    vim.lsp.config("pyright", {
      settings = {
        python = {
          pythonPath = PYTHON_HOST,
        },
      },
    })
  end,
})

vim.opt.fileformats = { "unix", "dos" }
vim.cmd([[
  autocmd BufWritePre * set ff=unix
]])
