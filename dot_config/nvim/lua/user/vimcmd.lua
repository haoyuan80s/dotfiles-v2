vim.cmd([[
  colorscheme tokyonight-night

  highlight Comment guifg=pink2

  if has('nvim') && executable('nvr')
    let $GIT_EDITOR = "nvr -cc tabedit --remote-wait +'set bufhidden=wipe'"
  endif
]])
