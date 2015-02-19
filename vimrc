set nocp ml cb=autoselectplus mouse=a et sw=2 ts=2 ai si so=7 ru nu hls bs=2 ww=bs,s,<,>,[,] acd scs is wmnu
filetype plugin on 
filetype indent on 
syntax enable 
map j gj
map k gk
map <Down> gj
map <Up> gk
let mapleader=","
nnoremap <Leader>e :e<Space>
nnoremap <Leader>z :w<Cr>
nnoremap <Leader>x :q<Cr>
nnoremap <Leader>c :tabnew<Cr>:e<Space>
nnoremap <Leader>v <C-w><C-v> 
nnoremap <Leader>b <C-w><C-s>
nnoremap <Leader>n <C-PageUp>
nnoremap <Leader>m <C-PageDown>
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l
nnoremap <Silent> <Leader>p :vert res -10<Cr>
nnoremap <Silent> <Leader>u :vert res +10<Cr>
nnoremap <Silent> <Leader>i :res -5<Cr>
nnoremap <Silent> <Leader>o :res +5<Cr>
