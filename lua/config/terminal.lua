-- Usa PowerShell como terminal padrão
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
  -- Configuração para Windows
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end
