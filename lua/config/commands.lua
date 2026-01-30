-- Função para executar comandos no shell padrão do Vim e mostrar a saída em um novo buffer
function ExecuteCommand(command)
  -- Abre um novo buffer
  vim.cmd("new")
  vim.cmd("resize 10") -- Define a altura da janela para 10 linhas
  local buf = vim.api.nvim_get_current_buf() -- Obtém o buffer atual

  -- Executa o comando no shell padrão e redireciona a saída
  local term_id = vim.fn.termopen(command, {
    on_exit = function(_, _)
      vim.cmd("setlocal buftype=nofile") -- Define o buffer como um arquivo não gravável
      vim.cmd("setlocal bufhidden=wipe") -- Remove o buffer ao fechar
    end,
  })

  vim.cmd("startinsert") -- Coloca o terminal em modo de inserção
end

-- Mapeamento de teclas para executar o comando
vim.api.nvim_set_keymap(
  "n",
  "<leader>r",
  ':lua ExecuteCommand(vim.fn.input("Command: "))<CR>',
  { noremap = true, silent = true }
)
