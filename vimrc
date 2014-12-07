" Kel's personal Vimrc, mostly forked from http://github.com/amix/vimrc 
" with some snippets from vim wikia and love from the vim manuals

" Sections:
" → General
" → Indentation
" → Shortcuts
" → Interface
" → Behavior
" → Helper functions

" recategorize me!!!
let mapleader = "," " Enable <leader> as said key
let g:mapleader = "," " make <leader> said key inside functions

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

" ¶ Shortcuts
" Saving
nmap <C-s> :w<CR>
" Copy/cut/paste, respectively
vnoremap <C-c> "+y "
vnoremap <C-x> "+x
map <C-v> "+gP
" Moving around windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
" Moving around tabs
map <C-n> <C-PageDown>
map <C-p> <C-PageUp>
nnoremap <C-t> :tabedit<Space>
inoremap <C-t> <Esc>:tabedit<Space>
nnoremap <C-w> :q<CR>
inoremap <C-w> <Esc>:q<CR>

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
set wildmenu " Nicer tab completion
set wildignore=*.o,*~,*.pyc " Ignore compiled files in tab completion
set backspace=eol,start,indent " Normalize backspace behavior
set whichwrap=b,s,<,>,[,] " Allow wrap on certain keys
" Treat wrapped lines like newlines
map j gj
map k gk
map <Down> gj
map <Up> gk
set smartcase " Be case sensitive if uppercase chars are used in search
set incsearch " Makes search act like search in modern browsers
set magic " Make regexes portable/normalized
set switchbuf=useopen,usetab,newtab " Switch to buf if active when opening

" Visual mode pressing * or # searches for the current selection
vnoremap <Silent> * :call VisualSelection('f')<CR>
vnoremap <Silent> # :call VisualSelection('b')<CR>
cmap <C-v> <C-r>+
exe 'inoremap <Script> <C-v>' paste#paste_cmd['i']
exe 'vnoremap <Script> <C-v>' paste#paste_cmd['v']
noremap <C-q> <C-v>
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>


" ¶ Editing mappings
" Remap Vim 0 to first non-blank character
map 0 ^
" Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()
autocmd BufWrite *.js :call DeleteTrailingWS()


" ¶ Helper functions
function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
    call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  en
  return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")
  
  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l.currentBufNum)
  endif
endfunction
