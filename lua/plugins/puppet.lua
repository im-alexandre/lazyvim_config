return {
	"neovim/nvim-lspconfig",
	opts = function(_, opts)
		local server = {}
		if vim.fn.has("win32") == 1 then
			local ruby_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "puppet-ruby", "bin")
			if vim.fn.executable(vim.fs.joinpath(ruby_bin, "ruby.exe")) == 1 then
				server.cmd_env = { PATH = ruby_bin .. ";" .. vim.env.PATH }
				-- O cache do Puppet Editor Services 2.0.4 falha com o JSON do Ruby 3.4.
				server.cmd = { "puppet-languageserver", "--stdio", "--no-cache" }
			end
		end
		opts.servers.puppet = server
	end,
}
