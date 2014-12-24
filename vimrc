" “People get used to anything. The less you think about your oppression, the
" more your tolerance for it grows. After a while, people just think
" oppression is the normal state of things. But to become free, you have to be
" acutely aware of being a slave.” - Assata Shakur
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
set nobk " don't make permanent backups when overwriting files
set nowb " don't make temporary backups before overwriting files 
set noswf " don't make backup files for active vim buffers
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
" Open a file
nnoremap <C-e> :e<Space>
inoremap <C-e> <Esc>:e<Space>
" Saving
nnoremap <C-z> :w<Cr>
inoremap <C-z> <Esc>:w<Cr>
" Close current buffer
nnoremap <C-x> :q<Cr>
" Open new tab
nnoremap <C-c> :tabnew<Cr>:e<Space>
inoremap <C-c> <Esc>:tabnew<Cr>:e<Space>
" Split Vertically
nnoremap <C-v> <C-w><C-v> 
" Split Horizontally
nnoremap <C-b> <C-w><C-s>
" Moving around tabs
nnoremap <C-n> <C-PageUp>
nnoremap <C-m> <C-PageDown>
" Moving around windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Resizing windows
nnoremap <Silent> <C-p> :vert res -10<Cr>
nnoremap <Silent> <C-u> :vert res +10<Cr>
nnoremap <Silent> <C-i> :res -5<Cr>
nnoremap <Silent> <C-o> :res +5<Cr>
