" 1.Vim configuration

set history=200	" Set history of Ex commands
" set tabstop=4 " Set tab size
set number " Display line number

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch
set background=light
hi Search cterm=NONE ctermfg=black ctermbg=yellow

" The mapleader has to be set before vundle starts loading all
" the plugins.
let mapleader=","
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>bol :browse oldfiles<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

set nocompatible
filetype off	" required

"----------------------------------------------------"
" 2.Set the runtime path to include Vundle and initilize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin for wrapping a selection
Plugin 'tpope/vim-surround'
" Plugin YouCompleteMe
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'

" Plugin for commenting and uncommenting lines of code in all languages
" supported by Vim
Plugin 'tpope/vim-commentary'

" File system explorer for Vim editor
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" A Git wrapper so awesome
" Plugin 'tpope/vim-fugitive'

" Required, plugins available after
call vundle#end()		" required
filetype plugin indent on	" required

" let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
" let g:ycm_always_populate_location_list=1
" let g:ycm_clangd_binary_path = '/.vim/bundle/YouCompleteMe/third_party/ycmd/third_party/clangd/output/clangd'
" Because ycm core built with python 2
let g:ycm_server_python_interpreter = '/usr/bin/python2'
" Set loglevel to debug when ycm fail to print debug info to file
" let g:ycm_server_log_level = 'debug'
let g:ycm_confirm_extra_conf = 0

highlight YcmErrorSection guibg=#f7dc6f
highlight YcmWarningSection guibg=#f7dc6f
highlight YcmWarningLine guibg=#f7dc6f

" 3. Vim mapping

map <C-n> :NERDTreeToggle<CR>

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

"Map to traverse the buffer list
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

"Automatic closing brackets for Vim
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

"-----------------------------------------------------------------------"
" Set up cscope for vim
source ~/.vim/bundle/cscope/cscope_maps.vim

" Customize tab key in commandline mode as bash shell
set wildmode=longest,list

""""""""NERDTree Configuration""""""""""""
" Open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Automatically close NERDTree if it's the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Make NerdTree looks nice and disable 'Press ? for help'
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
