" Kel's personal Vimrc, mostly forked from http://github.com/amix/vimrc 
" with some snippets from vim wikia and a lot of love from the vim manuals

" Sections:
" → General
" → Indentation
" → Interface
" → Behavior
" → Shortcuts

" ¶ General
set encoding=utf8 " Set the standard encoding
set ffs=unix,dos,mac " Use Unix <EOL>s
set autoread " Set to auto read when a file is changed from the outside
set viminfo^=% " Remember info about open buffers on close
set nobackup " don't make permanent backups when overwriting files
set nowb " don't make temporary backups before overwriting files 
set noswapfile " don't make backup files for active vim buffers
set history=1500 " Sets how many lines of history Vim has to remember
set mouse=a " Enable mouse for all modes
filetype plugin on " Enable filetype plugin
filetype indent on " Enable autoindent plugin

" ¶ Indentation
set expandtab " Use spaces as tabs
set shiftwidth=2 " Number of spaces for autoindent
set tabstop=2 " Number of spaces <Tab> accounts for
set ai " Copy indent from current line when starting a new one
set si " Increase indent level in some cases

" ¶ Interface
syntax enable " Enable syntax highlighting
colorscheme default " Make the editor colorful
set background=dark " Change this based on terminal emulator colorscheme
set wrap " Visually wrap lines that are wider than the view
set so=7 " Lines to the cursor when moving window vertically
set ruler " Always show current position
set stal=2 " Always show tab page labels
set number " Show line numbers
set cmdheight=1 " Height of the command bar
set hid " A buffer becomes hidden when it is abandoned
set hlsearch " Highlight search results
set lazyredraw " Don't redraw while executing macros
set showmatch " Show matching brackets when cursor is over them
set mat=2 " How many tenths of a second to blink when matching brackets
set noerrorbells " No annoying sound on errors
set novisualbell " No annoying flashing on errors
set tm=500 " I have no idea what this does
set laststatus=2 " Always show the status line
set statusline="%<%f%8* %r%{&bomb?'!':''} %*%=%9*%m%* 0x%02B %l:%c%V %P/%LL"
set title " Set window title to titlestring 

" ¶ Behavior
set magic " Make regexes portable/normalized
set smartcase " Be case sensitive if uppercase chars are used in search
set incsearch " Makes search act like search in modern browsers
set wildmenu " Nicer tab completion
set wildignore=*.o,*~,*.pyc " Ignore compiled files in tab completion
set switchbuf=useopen,usetab,newtab " Switch to buf if active when opening
set backspace=eol,start,indent " Normalize backspace behavior
set whichwrap=b,s,<,>,[,] " Allow wrap on certain keys
" Treat wrapped lines like newlines
map j gj
map k gk
map <Down> gj
map <Up> gk

" ¶ Shortcuts
" Saving
noremap <C-s> :w<CR>
" Copy/cut/paste, respectively
vnoremap <C-c> "+y "
vnoremap <C-x> "+x
noremap <C-v> "+gP
" Moving around windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
" Moving around tabs
noremap <C-n> <C-PageDown>
noremap <C-p> <C-PageUp>
" Opening new tabs and windows
noremap <C-t> <Esc>:tabedit<CR>
noremap <C-n> <C-w>n 
" Open a file
noremap <C-o> <Esc>:e<Space><Tab>
" Close current window or tab
noremap <C-q> <Esc>:q<CR>
" Open a new tab with the current buffer's path
noremap <C-e> <Esc>:tabedit <C-r>=expand("%:p:h")<CR>/
" Switch CWD to the directory of the open buffer
noremap <C-g> :cd %:p:h<cr>:pwd<cr>
