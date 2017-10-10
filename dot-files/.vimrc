" VIM configuration

set number
set hlsearch
set ruler
set ignorecase
set background=dark
set laststatus=2
set tabstop=4
syntax on
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set showmatch

" Refer to: https://github.com/PytLab/dotfiles/blob/master/.vimrc
function HeaderBash()
    call setline(1, "#!/usr/bin/env bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()

