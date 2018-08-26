syntax on

set nowrap
colorscheme zellner

augroup VimrcFileTypeAutocommands
    au BufRead,BufNewFile *.conf                        setlocal filetype=javascript
augroup END
