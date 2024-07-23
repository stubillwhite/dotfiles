" vim:fdm=marker

" Prerequisites                                                             {{{1
" ==============================================================================

" Set <Leader> to something easier to reach
let mapleader=","
let g:mapleader=","


" Functions                                                                 {{{1
" ==============================================================================

" General Vim functions             {{{2
" ======================================

" Set all the relevant tab options to the specified level
function s:TabStop(n)
    silent execute 'set tabstop='.a:n
    silent execute 'set shiftwidth='.a:n
    silent execute 'set softtabstop='.a:n
endfunction
command -nargs=1 TabStop call s:TabStop(<f-args>)

" Settings                                                                  {{{1
" ==============================================================================

" General settings
set nobackup                                " Don't use backup files
set hidden                                  " Keep buffers open when not displayed
set ruler                                   " Show the file position
set copyindent                              " Copy indentation characters
set showcmd                                 " Show incomplete commands
set noshowmode                              " Don't show the active mode, mirrored in lightline
set incsearch                               " Search incrementally
set hlsearch                                " Search highlighting
set history=1000                            " Keep more history
set visualbell                              " No beep
set expandtab                               " No tabs
set nowrap                                  " No wrapping text
set nojoinspaces                            " Single-space when joining sentences
set title                                   " Set the title of the terminal
set ignorecase                              " Case insensitive by default...
set smartcase                               " ...but case sensitive if term includes uppercase
set scrolloff=2                             " Keep some context when scrolling vertically
set sidescrolloff=2                         " Keep some context when scrolling horizontally
set nostartofline                           " Keep horizontal cursor position when scrolling
set formatoptions+=n                        " Format respects numbered/bulleted lists
set iskeyword+=-                            " Dash is part of a word for movement purposes
set virtualedit=                            " No virtual edit
set timeoutlen=500                          " Timeout to press a key combination
set report=0                                " Always report changes
set undofile                                " Allow undo history to persist between sessions
set path=.,,.\dependencies\**               " Search path
set tags=./tags,../../tags                  " Default tags files
set listchars=tab:>-,eol:$                  " Unprintable characters to display
set laststatus=2                            " Always have a statusline
TabStop 4                                   " Default to 4 spaces per tabstop

syntax on                                   " Syntax highlighting

" Enable extended character sets
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc

" Misc options
let g:netrw_altv=1                          " Netrw vertical split puts cursor on the right

set t_Co=256
set term=xterm-256color
set termguicolors
colorscheme slate

syntax on

" File types                                                                {{{1
" ==============================================================================

augroup VimrcFileTypeAutocommands
    au BufRead,BufNewFile *.conf                        setlocal filetype=javascript
augroup END

" Key mappings                                                              {{{1
" ==============================================================================

" <Space> in normal mode removes highlighted search
nnoremap <Space> :nohlsearch<Return>:echo "Search highlight off"<Return>

" Use semi-colon as an alias for colon for easier access to Ex commands. Unmap
" colon to force your fingers to use it.
nnoremap ; :
vnoremap ; :

" Swap ` and ' because ` functionality is more useful but the key is hard to reach
nnoremap ' `
nnoremap ` '

" Navigate wrapped lines more easily
nnoremap j gj
nnoremap k gk

" VimTip #171 -- Search for visually selected text
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
