-- Detectar o Python do ambiente Conda ativo (ou base)
local conda_prefix = os.getenv("CONDA_PREFIX")
local python_host = nil
if conda_prefix and #conda_prefix > 0 then
  python_host = conda_prefix:gsub("\\", "/") .. "/python.exe"
else
  -- tentar derivar o base pelo CONDA_EXE
  local conda_exe = os.getenv("CONDA_EXE")
  if conda_exe and #conda_exe > 0 then
    python_host = conda_exe:gsub("\\", "/"):gsub("/Scripts/conda.exe", "/python.exe")
  else
    python_host = "D:/tools/anaconda3/python.exe" -- fallback pro seu base
  end
end

if os.getenv("CONDA_PYTHON_EXE") then
  PYTHON_HOST = os.getenv("CONDA_PYTHON_EXE")
else
  PYTHON_HOST = os.getenv("CONDA_PREFIX" .. "python.exe")
end

vim.lsp.config("jedi-language-server", {
  cmd = { PYTHON_HOST, "-m", "jedi-language-server" },
})

vim.opt.fileformats = { "unix", "dos" }
vim.cmd([[
  autocmd BufWritePre * set ff=unix
]])
