" auto/text.vim
" once {

if !NVPMTEST&&exists('TEXTAUTOLOAD')|finish|else|let TEXTAUTOLOAD=1|endif

" end-once}
" priv {

" }
" publ {

fu! s:just(...) range "{
  if a:0|let tw=&tw|let &tw=a:1|endif
  exe a:firstline
  exe 'norm! V'.a:lastline.'Ggq'
  let lastline=line('.')
  let s=@/|exe 'silent '.a:firstline.','.lastline.'s/\s\+/ /ge'|let @/=s
  let i=a:firstline
  while i<=lastline "NOT a:lastline!!!
    exe i
    let i=i+1
    if getline('.') !~ '\w\s'
      continue
    endif
    while strlen(substitute(getline('.'),'.','x','g'))<&tw
      silent! norm! E
      if strpart(getline('.'),col('.'))=~'^\s*$'
        norm! ^E
      endif
      exe "norm! a \<Esc>"
    endw
  endw
  if a:0
    let &tw=tw
  endif
endf " }

" }
" objc {

fu! text#text() "{

  let self = {}

  let self.just = function("s:just")

  return self

endf "}

" }
