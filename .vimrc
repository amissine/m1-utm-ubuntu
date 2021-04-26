syntax on
filetype plugin indent on

set number
set tabstop=2     " show existing tab with 2 spaces width
set shiftwidth=2  " when indenting with '>', use 2 spaces width
set expandtab     " on pressing tab, insert 2 spaces
inoremap <S-Tab> <C-V><Tab>

set backspace=indent,eol,start

set autowrite     " to save your file when you call :make - used by vim-go
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>

set foldmethod=marker
set mouse-=a

colorscheme peachpuff
