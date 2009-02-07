" The obvious ones
syntax on
filetype on
filetype plugin on
filetype indent on
set backspace=indent,eol,start

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

" When scrolling, keep 3 lines of context visible
" (start scrolling when the caret is 3 lines away from the
"  edge of the screen)
set scrolloff=3

" Incremental search + highlight matches
set hlsearch
set incsearch

" smart indenting
set cindent
set formatoptions=tcqor
set cino=:0,g0,+0,:0
set nolist

" list trailing spaces as asterisks
set listchars=tab:>-,trail:·,eol:$

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

"" ...use tabs, though, for certain file types, like make
autocmd FileType make   set noexpandtab

" For FuzzyFinder
let g:fuzzy_ceiling= 50000
let g:fuzzy_ignore = "objc/*, obj1c/*, objr/*, obj1r/*, .git/*"
let g:fuzzy_matching_limit = 70

set ruler
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=b

" Folding
" Also, set the foldlevel a bit higher, so some toplevel
" folds are open by default
set foldmethod=indent
set foldlevel=2

colo delek

"""
""" Key mappings {{{

" To get rid of the highlights
nmap <silent> <leader>n :silent :nohlsearch<CR>

"
" Per-system clipboard settings
"
if has("mac")
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
    nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p
elseif has("msdos")
    " msdos {{{
    " backspace in Visual mode deletes selection
    vnoremap <BS> d

    " CTRL-X and SHIFT-Del are Cut
    vnoremap <C-X> "+x
    vnoremap <S-Del> "+x

    " CTRL-C and CTRL-Insert are Copy
    vnoremap <C-C> "+y
    vnoremap <C-Insert> "+y

    " CTRL-V and SHIFT-Insert are Paste
    map <C-V>		"+gP
    map <S-Insert>		"+gP

    cmap <C-V>		<C-R>+
    cmap <S-Insert>		<C-R>+

    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.

    exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']
    
    " Use CTRL-Q to do what CTRL-V used to do
    noremap <C-Q>		<C-V>
    " }}} msdos
endif

" FuzzyFinder
map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>f :FuzzyFinderFile<CR>

" Moving between tabs
noremap ^n :gt<CR>
noremap ^p :gT<CR>

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

""" }}}
