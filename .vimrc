set nocompatible

" Incremental search + highlight matches
set hlsearch
set incsearch

" smart indenting
set cindent
set formatoptions=tcqor
set cino=:0,g0,+0,:0
set nolist

" list trailing spaces as asterisks
set listchars=trail:*

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

"" Use spaces instead of tabs
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set ruler
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=b

" Make the clipbaord work for C-c and C-v
vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p

colo delek
syntax on
