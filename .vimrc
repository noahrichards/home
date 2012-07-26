" First, clear all autocommands, in case this file is sourced twice
autocmd!

" Pathogen, front and center
call pathogen#infect()

" Check for mac, which is unix + uname returns "Darwin"
let s:system = "unknown"
if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin\n"
    let s:system = "mac"
  endif
endif

"""""""""""""""""""""""""""""""""""
""" Global Settings
"""""""""""""""""""""""""""""""""""

" The obvious ones
syntax on
filetype on
filetype plugin on
filetype indent on
set backspace=indent,eol,start

" Restore file location when opening a file
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exec "normal! g'\"" | endif
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

" Use spaces instead of tabs, except for make files
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
autocmd FileType make set noexpandtab

" Default textwidth is 80, but let some be a bit wider
set textwidth=80
autocmd BufNewFile,BufRead *.vimrc setlocal textwidth=120

" Turn on the lower ruler (mode, cursor position, file percentage)
set ruler

" Hide most of the gui schtuff (in MacVim or gvim)
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=b

" Folding off
set foldmethod=indent
set foldlevel=100

" Make quickfix use existing tabs or open new tabs, instead of using the same
" window.
set switchbuf=usetab,newtab

" For FuzzyFinder
let g:fuzzy_ceiling= 50000
let g:fuzzy_ignore = "objc/*, obj1c/*, objr/*, obj1r/*, .git/*"
let g:fuzzy_matching_limit = 70
" Flip open and open-in-tab for fuzzy finder
let g:fuf_keyOpen = '<C-l>'
let g:fuf_keyOpenTabpage = '<CR>'

"""""""""""""""""""""""""""""""""""
""" Filetype-specific settings
"""""""""""""""""""""""""""""""""""
autocmd! BufRead,BufNewFile *.mkd,*.markdown setfiletype mkd |
      \set ai formatoptions=tcroqn2 comments=n:>

autocmd BufRead *.vala,*.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead,BufNewFile *.vala,*.vapi setfiletype vala
let vala_comment_strings = 1

" Turn on spell checking for text files by default.
autocmd BufRead,BufNewFile *.txt,*.text setlocal spell spelllang=en_us

"""""""""""""""""""""""""""""""""""
""" Helpful functions
"""""""""""""""""""""""""""""""""""

"" Markdown
function! MarkdownCurrentFile()
    let l:filename = getreg("%")
    call MarkdownFile(l:filename)
endfunction

function! MarkdownFile(filename)
    let l:htmlname = "html/" . fnamemodify(a:filename, ":r") . ".html"
    silent exec "!Markdown " . a:filename . " > " l:htmlname
    if s:system == "mac"
      silent exec "!open " . l:htmlname
    endif
    redraw!
    echo "Wrote " . l:htmlname
endfunction

function! MarkdownCurrentDirectory()
    let l:mkdfiles = split(glob("*.mkd"), "\n")
    for l:file in l:mkdfiles
        call MarkdownFile(l:file)
    endfor
endfunction

"" Open .cc, .h., and _unittest.cc of the current cpp file
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

"""""""""""""""""""""""""""""""""""
""" Per-system clipboard settings
"""""""""""""""""""""""""""""""""""
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
  exec 'inoremap <script> <C-V>' paste#paste_cmd['i']
  exec 'vnoremap <script> <C-V>' paste#paste_cmd['v']

  " Use ctrl-q/ctrl-e to do what ctrl-v used to do
  " (ctrl-q is reserved in linux terms)
  noremap <C-E> <C-V>
  noremap <C-Q> <C-V>
endif

"""""""""""""""""""""""""""""""""""
""" Whitespace and line-length
"""""""""""""""""""""""""""""""""""

" Highlight lines that are too long (over textwidth in length)
function! HighlightTooLongLines()
  highlight def link RightMargin Error
  if &textwidth != 0
    let longlines = matchadd('RightMargin', '\%>'.&textwidth.'v.\+')
  endif
endfunction
autocmd BufEnter * call HighlightTooLongLines()

" Highlight trailing whitespace in red and strip it on buffer write.
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * let b:wsmatch = matchadd('ExtraWhitespace', '\s\+$')
autocmd InsertEnter * call matchdelete(b:wsmatch) |
      \let b:wsmatch = matchadd('ExtraWhitespace', '\s\+\%#\@<!$')
autocmd InsertLeave * call matchdelete(b:wsmatch) |
      \let b:wsmatch = matchadd('ExtraWhitespace', '\s\+$')

" Strip trailing whitespace on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

"""""""""""""""""""""""""""""""""""
""" Keybindings (<leader> shortcuts)
"""""""""""""""""""""""""""""""""""

map <leader>b :FufBuffer<CR>
map <leader>f :FufFile<CR>
map <leader>F :FufFileWithCurrentBufferDir<CR>
nmap <silent> <leader>n :silent :nohlsearch<CR>
map <leader>n :exec 'NERDTreeToggle ' . getcwd()<CR>
" ,s to turn on/off show whitespace
nmap <silent> <leader>s :set nolist!<CR>
" Opening new files
if has("unix")
  map <leader>o :tabe <C-R>=simplify(expand("%:h") . "/") <CR>
else
  map <leader>o :tabe <C-R>=simplify(expand("%:h") . "\\") <CR>
endif
nmap <leader>m :call MarkdownCurrentFile()<CR>
nmap <leader>M :call MarkdownCurrentDirectory()<CR>
nmap <leader>t :TagbarToggle<CR>
nmap <silent> <leader>w :setlocal spell spelllang=en_us<CR>

" GoToRelatedFile for cpp files
autocmd FileType cpp nnoremap <leader>h :call GoToRelatedFile(".h")<CR>
autocmd FileType cpp nnoremap <leader>c :call GoToRelatedFile(".cc")<CR>
autocmd FileType cpp nnoremap <leader>u :call GoToRelatedFile("_unittest.cc")<CR>

" Ignore annoying typos
command! Q q
command! Wq wq

"""""""""""""""""""""""""""""""""""
""" Load machine-specific config
"""""""""""""""""""""""""""""""""""
if filereadable($HOME.'/.vimrc-machine')
  source $HOME/.vimrc-machine
endif

