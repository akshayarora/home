set nocompatible
filetype off

set hidden
set ruler
set number

set nobackup
set noswapfile
set nowritebackup

set ignorecase

" show status line
set ls=2

set splitbelow
set splitright

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
" set smartindent

"mouse stuff
set mouse=a
set ttymouse=xterm2
set ttyfast

syntax on

set hlsearch
set incsearch

set wildmenu
set wildmode=longest,list

set directory=.,$TEMP
set guifont=Consolas:h12:cANSI
highlight Normal	guifg=gray guibg=black
" remove highlighting using <esc>
nnoremap <esc> :noh<return><esc>
" needed since Vim internally uses escape to represent special keys.
nnoremap <esc>^[ <esc>^[
" Copy Paste for OS X
vnoremap <C-c> :w !pbcopy
vnoremap <C-v> :r !pbcopy<CR><CR>

"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
"Plugin 'VundleVim/Vundle.vim'
"Plugin 'scrooloose/nerdtree'
"call vundle#end()
"filetype plugin indent on

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'fatih/vim-go'
"Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

call plug#end()

" NERDTree
" autocmd VimEnter * NERDTree
nmap \ :NERDTreeToggle<CR>
nmap \| :NERDTreeFind<CR>


" UltiSnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsSnippetDirectories = ['REPDIR/vim/snippets/']

" map <silent> <Leader>u :UltiSnipsEdit<CR>

" Help align code using regex, found online
fun! Align_Section(regex, ...) range
  let l:padding = a:0 ? a:1 : ' '

  let l:range   = a:firstline . ', ' . a:lastline
  let l:col     = 0
  let l:maxcol  = 0

  " Find the maximum column "
  let l:ln = a:firstline
  while l:ln <= a:lastline
    let l:sln = getline(l:ln)

    if l:sln =~ a:regex
      let l:col    = match(l:sln, a:regex)
      let l:maxcol = l:col > l:maxcol ? l:col : l:maxcol
    endif

    let l:ln     = l:ln + 1
  endwhile

  " Set them all "
  let l:ln = a:firstline
  while l:ln <= a:lastline
    let l:sln = getline(l:ln)

    if l:sln =~ a:regex
      let l:col = match(l:sln, a:regex)
      call setline(l:ln, strpart(l:sln, 0, l:col) . Pad('', l:maxcol-l:col, ' ') . strpart(l:sln, l:col) )
    endif

    let l:ln = l:ln + 1
  endwhile
endfun

fun! Pad(str, num, ...)
  let l:char = a:0 ? a:1 : ' '

  let l:str = a:str
  while strlen(l:str) < a:num
    let l:str = l:char . l:str
  endwhile
  return l:str
endfun

fun! Prompt(str, ...)
  let l:def = a:0 ? a:1 : ''

  call inputsave()
  exe "let l:ret = input(\"" . a:str . "\", \"" . l:def . "\" )"
  call inputrestore()

  return l:ret
endfun 

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

