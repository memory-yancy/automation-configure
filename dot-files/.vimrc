set number
set hlsearch
set ruler
set ignorecase
set background=dark
set laststatus=2
" always display the tabline, even if there is only one tab
set showtabline=2
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
set scrolloff=7

" about vim mapping:
"   * https://www.zhihu.com/question/20741941
"   * http://www.pythonclub.org/vim/map-basic
"   * http://stevelosh.com/blog/2010/09/coming-home-to-vim/
let mapleader = "\<Space>"

" Refer to: https://github.com/PytLab/dotfiles/blob/master/.vimrc
function! HeaderBash()
    call setline(1, "#!/bin/bash")
    normal G
    normal o
endf
autocmd bufnewfile *.sh call HeaderBash()
function! HeaderPython()
    call setline(1, "# coding: utf-8")
    normal G
    normal o
endf
autocmd bufnewfile *.py call HeaderPython()

" Refer to: https://github.com/huashengdun/vim-as-a-python-ide/blob/master/vimrc
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "DEBUG: installing vim-plug from https://github.com/junegunn/vim-plug ..."
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif
" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" https://github.com/junegunn/vim-plug and https://vimawesome.com/
call plug#begin('~/.vim/plugins')
Plug 'https://github.com/junegunn/vim-easy-align'
Plug 'https://github.com/scrooloose/nerdtree' | Plug 'https://github.com/Xuyuanp/nerdtree-git-plugin'
Plug 'https://github.com/Chiel92/vim-autoformat'
Plug 'https://github.com/editorconfig/editorconfig-vim'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/Yggdroot/indentLine'
Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/wkentaro-archive/conque.vim'
" theme plugin
Plug 'https://github.com/tomasr/molokai'
Plug 'https://github.com/wsdjeg/FlyGrep.vim'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/haya14busa/incsearch.vim'
Plug 'https://github.com/haya14busa/incsearch-easymotion.vim'
Plug 'https://github.com/prettier/vim-prettier'
Plug 'https://github.com/luochen1990/rainbow'
Plug 'https://github.com/airblade/vim-gitgutter'
" Plug 'https://github.com/davidhalter/jedi-vim'
Plug 'https://github.com/Valloric/YouCompleteMe'
" Plug 'https://github.com/powerline/powerline', {'tag': '2.6'}
" Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/liuchengxu/vim-which-key'
call plug#end()

" NERDTree
let NERDTreeShowLineNumbers = 1
nmap <F7> :NERDTreeToggle<CR>

" Tagbar
let g:tagbar_width = 30
" https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype': 'go',
    \ 'kinds': ['p:package', 'i:imports:1', 'c:constants', 'v:variables', 't:types', 'n:interfaces', 'w:fields', 'e:embedded', 'm:methods', 'r:constructor', 'f:functions'],
    \ 'sro': '.', 'kind2scope': {'t': 'ctype', 'n': 'ntype'}, 'scope2kind':{'ctype': 't', 'ntype': 'n'},
    \ 'ctagsbin': expand('~/go/bin/gotags'), 'ctagsargs': '-sort -silent'
    \ }
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
" Open result action manual:
"   * https://stackoverflow.com/questions/34906842/open-a-command-in-a-new-window
"   * https://github.com/Valloric/YouCompleteMe#the-gycm_goto_buffer_command-option
"   * https://github.com/wklken/k-vim/blob/master/vimrc.bundles
let g:ycm_goto_buffer_command = 'horizontal-split'
" Donot use jX to bind shortcut for YCM, since vim-easymotion support line jump
nmap <leader>gd :YcmCompleter GoTo<CR>
nmap <leader>gr :YcmCompleter GoToReferences<CR>
nmap <leader>gD :YcmCompleter GetDoc<CR>

" vim-gitgutter
set updatetime=100
let g:gitgutter_terminal_reports_focus=0

" vim-autoformat
" https://github.com/Chiel92/vim-autoformat#default-formatprograms
let g:autoformat_verbosemode=1

" Molokai
" colorscheme molokai
" set cursorline

" indentLine
" Keep original format for JSON if not IndentLinesDisable, see: https://github.com/Yggdroot/indentLine/issues/140#issuecomment-357620391

" vim-easyMotion
" https://github.com/easymotion/vim-easymotion#integration-with-incsearchvim
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<CR>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction
noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
