" Kel's personal Vimrc, mostly forked from github.com/amix/vimrc 
" with some snippets from vim wikia and a lot of love from the vim manuals
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
set vi^=% " Remember info about open buffers on close
set nobk " don't make permanent backups when overwriting files
set nowb " don't make temporary backups before overwriting files 
set noswf " don't make backup files for active vim buffers
set hi=100 " Sets how many lines of command history to remember
set mouse=a " Enable mouse use for all modes
filetype plugin on " Enable filetype plugin
filetype indent on " Enable autoindent plugin

" ¶ Indentation
set et " Use spaces in place of tabs
set sw=2 " Number of spaces for autoindent
set ts=2 " Number of spaces <Tab> accounts for
set ai " Copy indent from current line when starting a new one
set si " Increase indent level based on language heuristics 

" ¶ Interface
syntax enable " Enable syntax highlighting
colorscheme default " Make the editor colorful
set bg=dark " Colorscheme background; TODO: Remove 
set so=7 " Lines to the cursor when moving window vertically
set ru " Always show line and column number of cursor position
set nu " Show line numbers
set hid " Buffers become hidden when abandoned
set hls " Highlight search results
set lz " Don't redraw while executing macros
set sm " Show matching brackets when cursor is over them
set mat=2 " How many tenths of a second to blink matching brackets
set noeb " Disable audial error bells
set novb " Disable visual error bells 
set tm=500 " Time in ms to wait for key sequence to complete
set ls=2 " Always show the status line
set stl="%<%f%8* %r%{&bomb?'!':''} %*%=%9*%m%* 0x%02B %l:%c%V %P/%LL"
set title " Set graphical window title to titlestring 
set titlestring="filename [+=-] (path)" " Window title information

" ¶ Behavior
set bs=2 " Enable <Backspace> over all characters
set ww=b,s,<,>,[,] " Allow wrap on <Backspace>, <Space>, <Left>, and <Right>
" Treat wrapped lines like newlines
map j gj
map k gk
map <Down> gj
map <Up> gk
set acd " Automatically change working directory to current file's dir
set magic " Make regexes portable/normalized
set scs " Search case sensitive if uppercase chars are used 
set is " Highlight current search results 
set wmnu " Enhanced command-line completion
set swb=useopen,usetab,newtab " Buffer switching order

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
nnoremap <C-f> <C-w><C-s>
" Moving around tabs
nnoremap <C-n> <C-PageDown>
nnoremap <C-m> <C-PageUp>
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
