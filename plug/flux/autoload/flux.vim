" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

let s:rgex = {}

let s:rgex.proj = {}
let s:rgex.proj.name='^\s*\(-*\)\s*name\s*\(.*\)'
let s:rgex.proj.root='^\s*\(-*\)\s*root\s*\(.*\)'
let s:rgex.proj.proj='^\s*\(-*\)\s*\%(layout\|project\|proj\|pj\)\s*\(.*\)'
let s:rgex.proj.wksp='^\s*\(-*\)\s*\%(workplace\|workspace\|area\|ws\)\s*\(.*\)'
let s:rgex.proj.tabs='^\s*\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:rgex.proj.file='^\s*\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:rgex.proj.term='^\s*\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'

let s:rgex.line = {}
let s:rgex.iris = {}
let s:rgex.imux = {}

" }
" publ {

let s:proj = {}

fu! s:proj.load() "{

  let tree = {}

  if !empty(self.lines)

    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = '.'
    let tree.list = []
    let tree.last = 0

    for self.i in range(len(self.lines))

      let line = self.lines[self.i]

      let comment = match(line,'#')
      if comment + 1|let line = line[0:comment-1]|endif
      let line = trim(line)

      if !empty(matchstr(line,'^\s*---.*$'))|break|endif
      if  empty(line)|continue|endif

      " Project File 'name' {

      let self.match = matchlist(line,s:rgex.proj.name)
      let disabled   = trim(get(self.match,1)) == '-'
      if !disabled|let tree.name=get(self.match,2,tree.name)|endif

      " }
      " Project File 'root' {

      let self.match = matchlist(line,s:rgex.proj.root)
      let disabled   = trim(get(self.match,1)) == '-'
      if !disabled|let tree.root = get(self.match,2,tree.root)|endif

      " }
      " Project File 'proj' {

      let self.match = matchlist(line,s:rgex.proj.proj)
      let disabled   = trim(get(self.match,1)) == '-'
      if !disabled && !empty(self.match)|let tree.list+= [self.proj()]|endif

      " }

    endfor

    unlet self.i

  endif
  return tree

endf "}
fu! s:proj.proj() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.p in range(self.i+1,len(self.lines)-1)
    let line = self.lines[self.p]
    let self.match = matchlist(line,s:rgex.proj.wksp)
    if match(line,s:rgex.proj.proj)+1|break
    elseif !empty(self.match)
      call add(node.list,self.wksp())
    endif
  endfor

  unlet self.p

  return node

endf "}
fu! s:proj.wksp() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.w in range(self.p+1,len(self.lines)-1)
    let line = self.lines[self.w]
    let self.match = matchlist(line,s:rgex.proj.tabs)
    if match(line,s:rgex.proj.wksp)+1|break
    elseif !empty(self.match)
      call add(node.list,self.tabs())
    endif
  endfor

  unlet self.w

  return node

endf "}
fu! s:proj.tabs() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.t in range(self.w+1,len(self.lines)-1)
    let line = self.lines[self.t]
    let fmatch = matchlist(line,s:rgex.proj.file)
    let tmatch = matchlist(line,s:rgex.proj.term)
    if match(line,s:rgex.proj.tabs)+1|break
    elseif !empty(fmatch)
      let self.match = fmatch
      call add(node.list,self.file())
    elseif !empty(tmatch)
      let self.match = tmatch
      call add(node.list,self.term())
    endif
  endfor

  unlet self.t

  return node

endf "}
fu! s:proj.file() "{

  let node       = {}
  let node.type = 'f'
  let self.match = split(self.match[2],':')
  let node.name  = (len(self.match)>=1)?trim(self.match[0]):''
  let node.file  = (len(self.match)>=2)?trim(self.match[1]):''

  return node

endf "}
fu! s:proj.term() "{

  let node = {}
  let node.type = 't'
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.comm = (len(self.match)>=2)?trim(self.match[1]):''

  return node

endf "}

" }
" flux {

fu! flux#flux(...) "{

  let tree = {}
  if !empty(a:000)
    if len(a:000) == 1
      let s:proj.orig = a:000[0]
      let s:proj.lines = file#read(s:proj.orig)
      if !empty(s:proj.lines)|let tree=s:proj.load()|endif
    elseif a:000[1] == 'iris'
    elseif a:000[1] == 'line'
    elseif a:000[1] == 'imux'
    endif
  endif
  return tree

endf "}

" }
