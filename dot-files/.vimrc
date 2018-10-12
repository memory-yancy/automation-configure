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
set showcmd
set colorcolumn=120
" https://stackoverflow.com/questions/2447109/showing-a-different-background-colour-in-vim-past-80-characters
highlight ColorColumn ctermbg=235 guibg=#2c2d27
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" Refer to: https://github.com/PytLab/dotfiles/blob/master/.vimrc
function! HeaderBash()
    call setline(1, "#!/bin/bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()

" https://github.com/junegunn/vim-plug and https://vimawesome.com/
call plug#begin('~/.vim/plugins')
Plug 'https://github.com/junegunn/vim-easy-align'
Plug 'https://github.com/scrooloose/nerdtree' | Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'
Plug 'https://github.com/Chiel92/vim-autoformat'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/Yggdroot/indentLine'
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/wkentaro-archive/conque.vim'
Plug 'https://github.com/tomasr/molokai'
Plug 'https://github.com/wsdjeg/FlyGrep.vim'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/prettier/vim-prettier'
Plug 'https://github.com/luochen1990/rainbow'
" Plug 'https://github.com/davidhalter/jedi-vim'
Plug 'https://github.com/Valloric/YouCompleteMe'
" Plug 'https://github.com/powerline/powerline', {'tag': '2.6'}
" Plug 'https://github.com/vim-airline/vim-airline'
call plug#end()

" NERDTree
let NERDTreeShowLineNumbers = 1
nmap <F7> :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_width = 30
nmap <F8> :TagbarToggle<CR>

" Jedi-vim
" https://github.com/davidhalter/jedi-vim#i-dont-want-the-docstring-window-to-popup-during-completion
autocmd FileType python setlocal completeopt-=preview
" let g:jedi#popup_on_dot = 0
" let g:jedi#popup_select_first = 0

" Syntastic
" https://github.com/vim-syntastic/syntastic/issues/414#issuecomment-19312753
let g:syntastic_python_pylint_args = "-d C0103 -d C0111 -d W1202 -d C0301 -d R0201 -d C0411"
let g:syntastic_python_pylint_args_postfix = "-d C0103 -d C0111 -d W1202 -d C0301 -d R0201 -d C0411"
let g:syntastic_sh_shellcheck_args = "--exclude SC2086"
let g:syntastic_sh_shellcheck_postfix = "--exclude SC2086"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_balloons = 1
" let g:syntastic_check_on_wq = 0
nmap <F9> :SyntasticToggleMode<CR>

" Rainbow
let g:rainbow_active = 1

" YouCompleteMe
set encoding=utf-8
let g:ycm_complete_in_comments = 1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_confirm_extra_conf = 0

" Molokai
" colorscheme molokai
" set cursorline
