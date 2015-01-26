" “People get used to anything. The less you think about your oppression, the
"  more your tolerance for it grows. After a while, people just think
"  oppression is the normal state of things. But to become free, you have to be
"  acutely aware of being a slave.” - Assata Shakur
"
" Sections:
" → General
" → Indentation
" → Interface
" → Behavior
" → Shortcuts

" ¶ General
set enc=utf8 " Set the standard encoding
set ffs=unix,dos,mac " Use Unix <EOL>s
set ar " Set to auto read when a file is changed from the outside
set ml " Read for /* vim: */ modeline comments and set their options 
set nobk " don't make permanent backups when overwriting files
set nowb " don't make temporary backups before overwriting files 
set noswf " don't make backup files for active vim buffers
set cb=autoselectplus " Use system clipboard for yanking and pasting
set mouse=a " Enable mouse use for all modes
filetype plugin on " Load filetype-specific plugins
filetype indent on " Load filetype-specific indent patterns

" ¶ Indentation
set et " Use spaces in place of tabs
set sw=2 " Number of spaces for autoindent
set ts=2 " Number of spaces <Tab> accounts for
set ai " Copy indent from current line when starting a new one
set si " Increase indent level based on language heuristics 

" ¶ Interface
syntax enable " Enable syntax highlighting
set bg=dark " Colorscheme background; TODO: Remove 
set so=7 " Lines to the cursor when moving window vertically
set ru " Always show line and column number of cursor position
set nu " Show line numbers
set hls " Highlight search results

" ¶ Behavior
" Treat wrapped lines like newlines
map j gj
map k gk
map <Down> gj
map <Up> gk
set bs=2 " Enable <Backspace> over all characters
set ww=b,s,<,>,[,] " Allow wrap on <Backspace>, <Space>, <Left>, and <Right>
set acd " Automatically change working directory to current file's dir
set scs " Search case sensitive if uppercase chars are used 
set is " Jump to currently matching terms in search pattern as it's typed 
set wmnu " Enhanced command-line completion

" ¶ Shortcuts
let mapleader=","
" Open a file
nnoremap <Leader>e :e<Space>
" Saving
nnoremap <Leader>z :w<Cr>
" Close current buffer
nnoremap <Leader>x :q<Cr>
" Open new tab
nnoremap <Leader>c :tabnew<Cr>:e<Space>
" Split Vertically
nnoremap <Leader>v <C-w><C-v> 
" Split Horizontally
nnoremap <Leader>b <C-w><C-s>
" Moving around tabs
nnoremap <Leader>n <C-PageUp>
nnoremap <Leader>m <C-PageDown>
" Moving around windows
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
" Resizing windows
nnoremap <Silent> <Leader>p :vert res -10<Cr>
nnoremap <Silent> <Leader>u :vert res +10<Cr>
nnoremap <Silent> <Leader>i :res -5<Cr>
nnoremap <Silent> <Leader>o :res +5<Cr>
