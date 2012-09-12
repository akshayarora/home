set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set nu
set ai
set nobackup
set nowritebackup
set ts=3 sw=3
set smartindent
set directory=.,$TEMP
set guifont=Consolas:h12:cANSI
highlight Normal	guifg=gray guibg=black
" remove highlighting using <esc>
nnoremap <esc> :noh<return><esc>

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

