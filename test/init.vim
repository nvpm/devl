so plug/test/autoload/test.vim

" flux {

let s:flux = {}
fu! s:flux.init()  " {

  so plug/file/autoload/file.vim
  so plug/flux/autoload/flux.vim

  call self.proj.init()
  call self.temp.init()

endf " }

let s:flux.proj = {}
fu! s:flux.proj.init() " {

  for n in range(1,1)
    call self.test(n)
  endfor

endf " }
fu! s:flux.proj.test(n) " {

  let orig = 'test/flux/'.a:n.'-inpt'
  let expt = 'test/flux/'.a:n.'-expt'
  let tree = flux#flux(orig,'proj')
  let test = test#test()
  let test.orig = expt
  call test.eval()

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

let s:flux.temp = {}
fu! s:flux.temp.init() " {

  for n in range(1,1)
    call self.test(n)
  endfor

endf " }
fu! s:flux.temp.test(n) " {

  let orig = 'test/flux/'.a:n.'-inpt'
  let expt = 'test/flux/'.a:n.'-expt'
  let tree = flux#flux(orig,'temp')
  let test = test#test()
  let test.orig = expt
  call test.eval()

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

  let tree = flux#flux('.nvpm/proj/proj','proj')
  call flux#show('proj')
  "echo tree

endf " }

" }

"call s:flux.init()
call s:proj.init()

fu! NVPMTestTimer(timer)
  normal :<c-l><cr>
endf

call timer_start(NVPMTEST_timer_delay,'NVPMTestTimer')
