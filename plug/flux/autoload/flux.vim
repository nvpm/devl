" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv { 

let s:rgex = {}

let s:rgex.proj = {}
let s:rgex.proj.name='^\s*\(-*\)\s*\(name\)\s*\(.*\)'
let s:rgex.proj.root='^\s*\(-*\)\s*\(root\)\s*\(.*\)'
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
    let tree.root = './'
    let tree.list = []
    let tree.last = 0
    let self.jump = 0

    let self.i = 0
    let self.linesnr = len(self.lines)

    while self.i < self.linesnr
      let line = flux#line(self.lines[self.i])

      if (1+match(line,'^---'))||(line=='--')
        break
      endif
      if line=='-'
        let self.jump = 1
        let self.i+=1
        continue
      endif

      let self.match=matchlist(line,s:rgex.proj.name)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.i+=1|continue|endif
        let tree.name = self.match[3]
      endif

      let self.match=matchlist(line,s:rgex.proj.root)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.i+=1|continue|endif
        let tree.root = self.match[3]
      endif

      let self.match=matchlist(line,s:rgex.proj.proj)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.i+=1|continue|endif
        call add(tree.list,self.proj(tree.root))
      endif

      let self.jump = 0
      let self.i+=1
    endwhile

  endif
  return tree

endf "}
fu! s:proj.proj(root) "{

  let node={}
  let split=split(self.match[2],'[:=]',1)
  let node.name=split[0]
  let node.root = len(split)==1?'':split[1]
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  let node.list = []
  let node.last = 0

  let jump=0
  let break=0
  let self.p = self.i+1
  while self.p < self.linesnr
    let line = flux#line(self.lines[self.p])
    if 1+match(line,s:rgex.proj.proj)|break|endif
    if break|let self.p+=1|continue|endif
    let self.match = matchlist(line,s:rgex.proj.wksp)
    if (1+match(line,'^---'))||(line=='--')
      let self.i = self.p
      return node
    endif
    if line=='-'
      let jump=1
      let self.p+=1
      continue
    endif
    if !empty(self.match)&&!jump
      if self.match[1] == '--'|let break=1|continue|endif
      if self.match[1] == '-' |let self.p+=1|continue|endif
      call add(node.list,self.wksp(node.root))
    else
      let jump=0
    endif
    let self.p+=1
  endwhile
  let self.i = self.p-1

  return node

endf "}
fu! s:proj.wksp(root) "{

  let node={}
  let wksp=split(self.match[2],'[:=]',1)
  let node.name=wksp[0]
  let node.root = len(wksp)==1?'':wksp[1]
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  let node.list = []
  let node.last = 0

  return node
  let self.w = self.p+1
  let self.jump=0
  while self.w < self.linesnr
    let line = flux#line(self.lines[self.w])
    "if 1+match(line,s:rgex.proj.wksp)|break|endif
    "if (1+match(line,'^---'))||(line=='--')
      "let self.p = self.w
      "return node
    "endif
    "if line=='-'
      "let self.jump=1
      "let self.w+=1
      "continue
    "endif
    "let self.match = matchlist(line,s:rgex.proj.tabs)
    "if !empty(self.match)&&!self.jump
      "if self.match[1] == '--'|break|endif
      "if self.match[1] == '-' |let self.w+=1|continue|endif
      "call add(node.list,self.tabs(node.root))
    "endif
    let self.jump = 0
    let self.w+=1
  endwhile
  let self.p = self.w-1

  return node

endf "}
fu! s:proj.tabs(root) "{

  let node={}
  let tabs=split(self.match[2],'[:=]',1)
  let node.name=tabs[0]
  let node.root = len(tabs)==1?'':tabs[1]
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  let node.list = []
  let node.last = 0

  let self.t = self.w+1
  let self.jump=0
  while self.t < self.linesnr
    let line = flux#line(self.lines[self.t])
    if 1+match(line,s:rgex.proj.tabs)|break|endif
    if (1+match(line,'^---'))||(line=='--')
      let self.w = self.t
      return node
    endif
    if line=='-'
      let self.jump=1
      let self.t+=1
      continue
    endif
    " get file or term
    let self.jump = 0
    let self.t+=1
  endwhile
  let self.w = self.t-1

  return node

endf "}
fu! s:proj.file() "{

  let node       = {}
  let node.type = 'f'
  let self.match = split(self.match[2],'[:=]')
  let node.name  = (len(self.match)>=1)?trim(self.match[0]):''
  let node.file  = (len(self.match)>=2)?trim(self.match[1]):''

  return node

endf "}
fu! s:proj.term() "{

  let node = {}
  let node.type = 't'
  let self.match = split(self.match[2],'[:=]')
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
fu! flux#stop(line) "{
  return !empty(matchstr(a:line,'^\s*---'))
endf "}
fu! flux#line(line) "{
  let line = a:line
  let comment = match(line,'#')
  if 1+comment|let line = line[0:comment-1]|endif
  return trim(line)
endf "}

" }
