" saved {

so plug/test/autoload/test.vim

" file {

let s:file = {}

fu! s:file.init() " {

  so plug/file/autoload/file.vim

  call self.read()

endf " }
fu! s:file.read() " {

  let list = []
  let list+= ['hello']
  let list+= ['world']
  let orig = 'test/file/read'
  let file = file#read(orig)
  if !empty(file)
    if !test#diff(list,file)
      echohl NVPMTestPassed|echo 'nvpm.file.read passed'|echohl None
    else
      echohl NVPMTestFailed|echo 'nvpm.file.read failed'|echohl None
    endif
  else
    echohl NVPMTestWarning
    echo "nvpm.file.read could't read ".orig
    echohl None
  endif

endf "}

" }
" flux {

let s:flux = {}

fu! s:flux.init()  " {

  so plug/file/autoload/file.vim
  so plug/flux/autoload/flux.vim

  for n in range(1,1)
    call self.test(n)
  endfor

endf " }
fu! s:flux.test(n) " {

  let test = test#test()
  let test.orig = 'test/flux/'.a:n.'-expt'

  if !test.eval()
    echohl NVPMTestFailed
    echo 'nvpm.flux file test/flux/'.a:n.'-expt is unreadable'
    echohl None
  endif

  let orig = 'test/flux/'.a:n.'-inpt'
  let tree = flux#flux(orig)

  if empty(tree)
    echohl NVPMTestFailed
    echo 'nvpm.flux file test/flux/'.a:n.'-inpt is unreadable'
    echohl None
    return
  endif

  if !test#diff(tree,test.tree)
    echohl NVPMTestPassed|echo 'nvpm.flux.tes'.a:n.' passed'|echohl None
  else
    echohl NVPMTestFailed|echo 'nvpm.flux.tes'.a:n.' failed'|echohl None
  endif

endf " }

" }
" proj {

let s:proj = {}

fu! s:proj.init() " {

  so plug/file/autoload/file.vim
  so plug/flux/autoload/flux.vim

  so plug/proj/autoload/proj.vim
  so plug/proj/plugin/proj.vim

  call s:proj.load()

endf " }
fu! s:proj.load() " {

  ProjLoad proj

endf " }

" }

"call s:file.init()
"call s:flux.init()
call s:proj.init()

" }


