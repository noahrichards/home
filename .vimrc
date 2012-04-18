" Start with some pathogen, please!
call pathogen#infect()

" The obvious ones
syntax on
filetype on
filetype plugin on
filetype indent on
set backspace=indent,eol,start

" Restore file location when opening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Use , as the leader character instead of \
let mapleader = ","

" switch ' and `
nnoremap ' `
nnoremap ` '

" Keep a longer history than the default
set history=1000

" Use matchit for nicer % matching
runtime macros/matchit.vim

" Nicer filename/command completion with tab
set wildmenu
set wildmode=list:longest

" Bye-bye, vi
set nocompatible

" Use case-insensitive search by default, unless there is
" a capital letter in the search expression
set ignorecase
set smartcase

" When scrolling, keep 2 lines of context visible
" (start scrolling when the caret is 2 lines away from the
"  edge of the screen)
set scrolloff=2

" Incremental search + highlight matches
set hlsearch
set incsearch

" smart indenting
set cindent
set formatoptions=tcqor
set cino=:0,g0,+0,:0
set nolist

" list trailing spaces as asterisks
set listchars=tab:>-,trail:#,eol:$

" Turn off smarttab
set nosmarttab

" Don't keep around a permanent backup, but do keep around the temporary
" backups while a file is being edited (they get deleted on save/exit)
set nobackup
set writebackup

" Show matching parens
set showmatch

" When wordwrap is on, don't break in the middle of words
set linebreak
set showbreak=+

" Use spaces instead of tabs
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

" Default textwidth is 80, in all languages
set textwidth=80

"" ...use tabs, though, for certain file types, like make
autocmd FileType make set noexpandtab

"" Markdown

function! MarkdownCurrentFile()
    let l:filename = getreg("%")
    call MarkdownFile(l:filename)
endfunction

function! MarkdownFile(filename)
    let l:htmlname = "html/" . fnamemodify(a:filename, ":r") . ".html"
    silent exec "!Markdown " . a:filename . " > " l:htmlname
    silent exec "!open " . l:htmlname
    redraw!
    echo "Wrote " . l:htmlname
endfunction

function! MarkdownCurrentDirectory()
    let l:mkdfiles = split(glob("*.mkd"), "\n")
    for l:file in l:mkdfiles
        call MarkdownFile(l:file)
    endfor
endfunction

nmap <leader>m :call MarkdownCurrentFile()<CR>
nmap <leader>M :call MarkdownCurrentDirectory()<CR>

" Turn on the lower ruler (mode, cursor position, file percentage)
set ruler

" Hide most of the gui schtuff (in MacVim or gvim)
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=b

" Folding
" Also, set the foldlevel a bit higher, so some toplevel
" folds are open by default
set foldmethod=indent
set foldlevel=100

"colo delek

" To get rid of highlights
nmap <silent> <leader>n :silent :nohlsearch<CR>

"
" Per-system clipboard settings
"

" Check for mac, which is unix + uname returns "Darwin"
let s:system = "unknown"
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    let s:system = "mac"
  endif
endif

if s:system == "mac"
  " Mac uses pbcopy/pbpaste, no quote buffer here.
  vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
else " windows and unix are identical
  " backspace in Visual mode deletes selection
  vnoremap <C-X> "+x
  vnoremap <C-C> "+y
  map <C-V>      "+gP
  cmap <C-V>     <C-R>+

  " Pasting blockwise and linewise selections is not possible in Insert and
  " Visual mode without the +virtualedit feature.  They are pasted as if they
  " were characterwise instead.
  " Uses the paste.vim autoload script.
  exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
  exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

  " Use ctrl-q/ctrl-e to do what ctrl-v used to do
  " (ctrl-q is reserved in linux terms)
  noremap <C-E> <C-V>
  noremap <C-Q> <C-V>
endif

" Opening new files
if has("unix")
  map <leader>e :tabe <C-R>=expand("%:p:h") . "/" <CR>
else
  map <leader>e :tabe <C-R>=expand("%:p:h") . "\\" <CR>
endif

" For NERD tree
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" ,s to turn on/off show whitespace
nmap <silent> <leader>s :set nolist!<CR>
nmap <silent> <leader>w :setlocal spell spelllang=en_us<CR>

" Highlight trailing whitespace in red and strip it on buffer write.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Opening new files
if has("unix")
  map <leader>o :tabe <C-R>=simplify(expand("%:h") . "/") <CR>
else
  map <leader>o :tabe <C-R>=simplify(expand("%:h") . "\\") <CR>
endif

" Find .cc, .h., and _unittest.cc of the current file
function! GoToRelatedFile(extension)
  let l:filename = expand("%:r")
  if (l:filename =~ "_unittest$")
    let l:file = substitute(l:filename, "_unittest$", "", "") . a:extension
  else
    let l:file = l:filename . a:extension
  endif
  " TODO: Switch to existing tab, if one is open
  exec "tabe " . l:file
endfunction

" Map these only for c/c++
autocmd FileType cpp nnoremap <leader>h :call GoToRelatedFile(".h")<CR>
autocmd FileType cpp nnoremap <leader>c :call GoToRelatedFile(".cc")<CR>
autocmd FileType cpp nnoremap <leader>u :call GoToRelatedFile("_unittest.cc")<CR>

" Ignore annoying typos
command! Q q
command! Wq wq

" Make quickfix use existing tabs or open new tabs, instead of using the same
" window.
set switchbuf=usetab,newtab

" Check for machine-specific .vimrc overrides
if filereadable($HOME.'/.vimrc-machine')
  source $HOME.'/.vimrc-machine'
endif

