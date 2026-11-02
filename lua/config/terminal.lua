-- Usa PowerShell como terminal padrão
if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	local pwsh = vim.fn.exepath("pwsh.exe")
	if pwsh == "" then
		-- O terminal exige o executável real; o alias da Store não passa na verificação.
		local alias = vim.env.LOCALAPPDATA .. "\\Microsoft\\WindowsApps\\Microsoft.PowerShell_8wekyb3d8bbwe\\pwsh.exe"
		local result = vim.system({ alias, "-NoLogo", "-NoProfile", "-Command", "$PSHOME" }, { text = true }):wait()
		assert(result.code == 0, "Não foi possível localizar o PowerShell 7: " .. (result.stderr or ""))
		pwsh = vim.trim(result.stdout) .. "\\pwsh.exe"
	end
	vim.opt.shell = '"' .. pwsh .. '"'
	vim.opt.shellcmdflag = "-NoLogo -ExecutionPolicy Bypass -Command"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end
