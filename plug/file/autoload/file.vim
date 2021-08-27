" auto/file.vim
" once {

if !NVPMTEST&&exists('FILEAUTOLOAD')|finish|else|let FILEAUTOLOAD=1|endif

" end-once}
" objc {

fu! file#read(file) "{
  let lines = []
  try
    let lines = readfile(a:file)
  catch
    echon 'file: no such file "' . a:file . '"'
  endtry
  return lines
endf "}

" }
