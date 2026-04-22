local opts = { noremap = true, silent = true }


local K = vim.keymap.set

-- K("t", "<A-h>", "<C-\\><C-n><C-w>h")
-- K("t", "<A-j>", "<C-\\><C-n><C-w>j")
-- K("t", "<A-k>", "<C-\\><C-n><C-w>k")
-- K("t", "<A-l>", "<C-\\><C-n><C-w>l")
K("t", "<C-w><C-w>", "<C-\\><C-n><C-w><C-w>")
K("t", "<C-w>h", "<C-\\><C-n><C-w>h")
K("t", "<C-w>l", "<C-\\><C-n><C-w>l")
K("t", "<C-w>j", "<C-\\><C-n><C-w>j")
K("t", "<C-w>k", "<C-\\><C-n><C-w>k")

K("t", "<A-n>", "<C-\\><C-n>")

-- vim.keymap.set("n", "<leader>e", ":e ", { noremap = true })
-- vim.keymap.set('n', ';', ':')
-- vim.keymap.set('n', ':', ';')
-- vim.keymap.set('v', ';', ':')
-- vim.keymap.set('v', ':', ';')
-- K('i', '<C-l>', '<Right><C-h>', opts)
K('i', '<C-BS>', '<C-o>d^', opts)
K('i', '<C-S-w>', '<C-o>dw', opts)

-- K('i', '<C-k>', '<C-o>d$', opts)
-- <F5> == ctrl+space (insert mode leader key)
-- K('i', '<localleader>a', '<cmd>CopilotChatToggle<CR>', opts)
K('n', '<A-a>', '<cmd>CopilotChatToggle<CR>', opts)
K('i', '<A-a>', '<cmd>CopilotChatToggle<CR>', opts)
K('x', '<A-a>', '<cmd>CopilotChatToggle<CR>', opts)
-- K('n', '<localleader>a', '<cmd>CopilotChatToggle<CR>', opts)

K('n', '_', '<cmd>lua require("user.hao_play").switch_case()<CR>', opts)
K('n', 'yF', '<cmd>let @+ = expand("%:p")<CR><esc>', opts)
K('x', '<MiddleMouse>', '"+y', opts)
K('n', 'gy{', 'Vf{%y', opts)
K('n', 'gy(', 'Vf(%y', opts)
K('n', 'gy[', 'Vf[%y', opts)
-- K('o', 'S', '<cmd>HopLine<cr>', opts)
K('n', 's', '<cmd>HopChar1MW<cr>', opts)
K('x', 's', '<cmd>HopChar1MW<cr>', opts)
-- K('o', 's', '<cmd>HopChar1<cr>', opts)
K('n', '[p', '<cmd>pu!<cr>', opts) -- put prev line
K('n', ']p', '<cmd>pu<cr>', opts)  -- put next line
K('n', '<C-q>', '<C-^>', opts)
K('x', '<C-q>', '<esc><C-^>', opts)
K('i', '<C-q>', '<esc><C-^>', opts)
K('n', '<A-n>', '<cmd>cnext<cr>', opts)
K('n', '<A-p>', '<cmd>cprev<cr>', opts)
K('n', '<C-w>V', '<C-w>o<C-w>v', opts)
K('n', '<C-w>S', '<C-w>o<C-w>s', opts)
K('n', 'g*', 'viw<cmd>lua SaveVisualSelectionToSearchRegister()<CR>', opts)
K('x', 'g*', '<cmd>lua SaveVisualSelectionToSearchRegister()<CR>', opts)
K('n', 'zR', require('ufo').openAllFolds)
K('n', 'zM', require('ufo').closeAllFolds)
K("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
K("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

function SaveVisualSelectionToSearchRegister()
  vim.cmd('normal! "zy')
  local selected_text = vim.fn.getreg('z')
  local escaped_text = selected_text:gsub('/', '\\/'):gsub('%%', '%%%%'):gsub('%.', '\\.'):gsub("*", "\\*")
      :gsub("]", "\\]")
  print(escaped_text)
  vim.fn.setreg('/', escaped_text)
  vim.cmd('set hlsearch')
end

function repeatable_replace()
  vim.cmd('normal! v$h')          -- Simulates the `v$h` motion
  MiniOperators.replace("visual") -- Calls your Lua function
  vim.fn["repeat#set"]("gR")      -- Registers `gR` for repeat
end

vim.keymap.set("n", "gR", repeatable_replace, opts)


K('n', 'yA', 'mzggVGy`z', opts)
K('n', 'vA', 'ggVG', opts)
K('n', 'cA', 'ggVGc', opts)
K('n', 'dA', 'ggVGd', opts)
K('n', 'gcA', 'ggVG<Plug>(comment_toggle_linewise_visual)', opts)

K('n', '<C-j>', '10j', opts)
K('n', '<C-k>', '10k', opts)
K('x', '<C-j>', '10j', opts)
K('x', '<C-k>', '10k', opts)


K('n', 'grA', 'ggVG<cmd>lua MiniOperators.replace("visual")<CR>', opts)

K('n', '+', '<cmd>let @+=@" | echo "to system clipboard"<CR>', opts)
K('n', '-', '<cmd>let @"=@+ | echo "from system clipboard"<CR>', opts)







-- K('i', '<Down>', function() require("copilot.suggestion").next() end, opts)
-- K('i', '<Up>', function() require("copilot.suggestion").prev() end, opts)
-- K('i', '<Left>',
--   function()
--     require("copilot.suggestion").next()
--   end, opts)
-- K('i', '<Right>', function()
--   require("copilot.suggestion").accept()
--   -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
-- end, { expr = true, replace_keycodes = false })

K('i', '<Down>', '<Plug>(copilot-next)', opts)
K('i', '<Up>', '<Plug>(copilot-previous)', opts)
K('i', '<Left>', '<Plug>(copilot-suggest)', opts)
K('i', '<Right>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
K("i", "<C-Right>", '<Plug>(copilot-accept-world)',
  { noremap = true, silent = true, expr = true, replace_keycodes = false })

-- K('i', '<Down>', '<cmd>lua require("minuet.virtualtext").action.next()<CR>', opts)
-- K('i', '<Up>', '<cmd>lua require("minuet.virtualtext").action.prev()<CR>', opts)
-- K('i', '<Left>', '<cmd>lua require("minuet.virtualtext").action.next()<CR>', opts)
-- K('i', '<Right>', '<cmd>lua require("minuet.virtualtext").action.accept()<CR>', opts)
-- K("i", "<C-Right>", '<Plug>(copilot-accept-world)',
--   { noremap = true, silent = true, expr = true, replace_keycodes = false })

-- K('i', '<C-l>', '<Plug>(copilot-accept-word)')
-- K('i', '<A-l>', '<Plug>(copilot-accept-line)')

K('n', '<F12>', '<Plug>(comment_toggle_linewise_current)', opts)
K('v', '<F12>', '<Plug>(comment_toggle_linewise_visual)', opts)

vim.cmd [[
  if !exists('g:lasttab')
    let g:lasttab = 1
  endif
  nmap <leader>tl :exe "tabn ".g:lasttab<CR>
  au TabLeave * let g:lasttab = tabpagenr()

  inoremap        <C-A> <C-O>^
  inoremap   <C-X><C-A> <C-A>
  cnoremap        <C-A> <Home>
  cnoremap   <C-X><C-A> <C-A>

  inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
  cnoremap        <C-B> <Left>

  " inoremap <expr> <C-D> col('.')>strlen(getline('.'))?"\<Lt>C-D>":"\<Lt>Del>"
  " cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"

  inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

  inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
  cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"
]]
