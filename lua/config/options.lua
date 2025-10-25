-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "telescope"

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
