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
    call setline(1, "#!/bin/bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()

call plug#begin('~/.vim/plugins')
Plug 'https://github.com/junegunn/vim-easy-align'
Plug 'https://github.com/scrooloose/nerdtree' | Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'
Plug 'https://github.com/Chiel92/vim-autoformat'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/Yggdroot/indentLine'
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/powerline/powerline', {'tag': '2.6'}
Plug 'https://github.com/wkentaro-archive/conque.vim'
call plug#end()

" nerdtree
let NERDTreeShowLineNumbers=1

" tagbar
let g:tagbar_width = 25
