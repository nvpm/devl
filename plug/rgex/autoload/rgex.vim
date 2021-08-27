" auto/rgex.vim
" once {

if !NVPMTEST&&exists('RGEXAUTOLOAD')|finish|else|let RGEXAUTOLOAD=1|endif

" end-once}
" priv {

let s:b = '^'
let s:e = '$'

" }
" publ {

fu! s:encl(str) dict "{
  return s:b . a:str . s:e
endf "}
fu! s:pare(str) dict "{
  return '\('. a:str . '\)'
endf "}
fu! s:brac(str) dict "{
  return '\['. a:str . ']'
endf "}
fu! s:stop(str) dict "{
  return !empty(matchstr(a:str,'^\s*'.self.rgex_stop_char.'.*$'))
endf "}

" }
" objc {

fu! rgex#rgex() "{

  let self = {}

  let self.encl  = function("s:encl")
  let self.pare  = function("s:pare")
  let self.brac  = function("s:brac")
  let self.stop  = function("s:stop")

  let self.rgex_stop_char = '---'
  let self.rgex_comment   = '^\s*\#.*'

  return self

endf "}

" }
