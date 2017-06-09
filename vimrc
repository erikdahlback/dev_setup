"set exrc
set secure
set nocp

let mapleader = ","

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-abolish'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'majutsushi/tagbar'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/syntastic'
Plugin 'MattesGroeger/vim-bookmarks'
Plugin 'sjbach/lusty'
Plugin 'mileszs/ack.vim'
Plugin 'mihaifm/bufstop'
Plugin 'LucHermitte/lh-vim-lib'
Plugin 'LucHermitte/local_vimrc'
Plugin 'rodnaph/vim-color-schemes'
Plugin 'twerth/ir_black'
Plugin 'dietsche/vim-lastplace'
Plugin 'easymotion/vim-easymotion'

call vundle#end()
filetype plugin indent on

set laststatus=2

let g:airline#extensions#whitespace#mixed_indent_algo = 1
let g:airline#extensions#tabline#enabled = 1
let g:ackprg = 'ag --vimgrep -U --ignore cscope.out --ignore tags'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { "mode": "passive", "active_filetypes": [], "passive_filetypes": [] }

" let g:syntastic_mode_map = { "mode": "passive", "active_filetypes": ["c"], "passive_filetypes": [] }
" let g:syntastic_c_checkers = ['ninja']

let g:syntastic_c_checkers = ['ninja']
" let g:syntastic_c_make_args = ''
let g:syntastic_mode_map = { "mode": "passive", "active_filetypes": ["c"], "passive_filetypes": [] }

" let g:syntastic_debug = 1
let g:ctrlp_working_path_mode = ''
let g:ctrlp_max_files = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_max_depth = 40

"let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard -co']


let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['ctrlpfiles', 'cd %s && cat ctrlpfiles'],
		\ 2: ['cscope.files', 'cd %s && cat cscope.files'],
		\ 3: ['.git', 'cd %s && git ls-files --exclude-standard -co'],
		\ },
	\ 'fallback': 'find %s -type f'
	\ }

let g:gitgutter_map_keys = 0

nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk

let g:bookmark_save_per_working_dir = 0
let g:bookmark_auto_save = 1
let g:bookmark_auto_close = 1
let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1

let g:local_vimrc = '.vimrc.local'

set hidden
set wildignore=*.o

" execute pathogen#infect()


set hlsearch
set ignorecase

set guioptions-=T
set guioptions-=m

set guifont=Monospace\ 10

syntax on

filetype plugin indent on

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

set pastetoggle="<F12>"

autocmd FileType python setlocal tabstop=4|setlocal shiftwidth=4|setlocal expandtab
" autocmd FileType sh setlocal tabstop=8|setlocal shiftwidth=8|setlocal noexpandtab

map <C-n> :NERDTreeToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <F7> :w<CR>:SyntasticCheck<CR>
nmap <F6> :w<CR>:mak<CR>
map <leader>b :CtrlPBuffer<CR>
map <leader>a :BufstopModeFast<CR>
map <leader>p :CtrlPRoot<CR>

set tags=./tags;,./TAGS,tags,TAGS,src/os/linux-2.6/tags,os/linux-2.6/tags
