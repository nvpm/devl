" auto/test.vim
" once {

if !NVPMTEST&&exists('TESTAUTOLOAD')|finish|else|let TESTAUTOLOAD=1|endif

" end-once}
" priv {

" }
" publ {

fu! s:eval() dict  "{

  "let read = self.read()

  let lines = file#read(self.orig)

  try
    let self.tree = eval(join(lines))
    return 1
  catch
    let self.tree = {}
    return 0
  endtry

endf "}

" }
" objc {

fu! test#test() "{

  let self = {}

  let self.eval = function("s:eval")
  let self.orig = ''

  let self.tree = {}

  return self

endf "}
fu! test#diff(a,b) "{
  let a = a:a
  let b = a:b
  return type(a) != type(b) || a != b
endf "}

" }
