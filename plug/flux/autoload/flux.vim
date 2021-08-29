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

    let self.node = 'root'
    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = './'
    let tree.list = []
    let tree.last = 0
    let self.jump = 0

    let self.i = -1
    let self.linesnr = len(self.lines)

    while self.i < self.linesnr-1
      let self.i+=1
      let line = flux#line(self.lines[self.i])

      if (line=='---')||(line=='--'&&self.node=='root')
        break
      endif
      if line=='-'
        let self.jump = 1
        continue
      endif

      let self.match=matchlist(line,s:rgex.proj.name)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break   |endif
        if self.match[1] == '-' |continue|endif
        let tree.name = self.match[3]
      endif

      let self.match=matchlist(line,s:rgex.proj.root)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break   |endif
        if self.match[1] == '-' |continue|endif
        let tree.root = self.match[3]
      endif

      "let self.match=matchlist(line,s:rgex.proj.proj)
      "if !empty(self.match)&&!self.jump
        "if self.match[1]!='-'
          "let self.node = 'proj'
          "call add(tree.list,self.proj(tree.root))
          "let self.node = 'root'
        "endif
      "endif

      "let self.jump = 0
    endwhile

    "for self.i in range(len(self.lines)) "{

      "let line = flux#line(self.lines[self.i])

      "if (1+match(line,'^\s*---'))||(1+match(line,'^\s*--')&&self.node=='root')
        "break
      "endif

      "if 1+match(line,'^\s*-$')
        "let self.jump = 1
        "continue
      "endif

      "let self.match=matchlist(line,s:rgex.proj.name)
      "if !empty(self.match)&&!self.jump
        "if empty(matchstr(self.match[1],'--\|-'))
          "let tree.name = self.match[3]
        "endif
      "endif

      "let self.match=matchlist(line,s:rgex.proj.root)
      "if !empty(self.match)&&!self.jump
        "let tree.root = [tree.root,self.match[3]][self.match[1]!='-']
      "endif

      "let self.match=matchlist(line,s:rgex.proj.proj)
      "if !empty(self.match)&&!self.jump
        "if self.match[1]!='-'
          "let self.node = 'proj'
          "call add(tree.list,self.proj(tree.root))
          "let self.node = 'root'
        "endif
      "endif

      "let self.jump = 0

    "endfor "}

  endif
  "let self.node = 'root'
  return tree

endf "}
fu! s:proj.proj(root) "{

  let node={}
  let proj=split(self.match[2],'[:=]',1)
  let node.name=proj[0]
  let node.root = len(proj)==1?'':proj[1]
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  let node.list = []
  let node.last = 0

  let self.p = self.i
  while self.p < self.linesnr
    let self.p+=1
    let line = flux#line(self.lines[self.p])
  endwhile
  let self.i = self.p

  return node

  "for self.p in range(self.i+1,len(self.lines)-1)
    "let line = flux#line(self.lines[self.p])
    "let self.match = matchlist(line,s:rgex.proj.wksp)
    ""if 1+match(line,s:rgex.proj.proj)|return node|endif
    ""if 1+match(line,'^\s*--')        |return node|endif
    ""if (1+match(line,s:rgex.proj.proj))||
     ""\ (flux#stop(line))||
     ""\ (1+match(line,'^\s*--'))
      ""break
    ""elseif !empty(self.match) && self.match[1] != '-'
      ""call add(node.list,self.wksp(node.root))
    ""endif
  "endfor
  "let self.i = self.p+1

endf "}
fu! s:proj.wksp(root) "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],'[:=]')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.w in range(self.p+1,len(self.lines)-1)
    let line = flux#line(self.lines[self.w])
    let self.match = matchlist(line,s:rgex.proj.tabs)
    if (match(line,s:rgex.proj.wksp)+1)||
     \ (flux#stop(line))||
     \ (1+match(line,'^\s*--'))
      break
    elseif !empty(self.match) && self.match[1] != '-'
      call add(node.list,self.tabs())
    endif
  endfor

  return node

endf "}
fu! s:proj.tabs() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],'[:=]')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.t in range(self.w+1,len(self.lines)-1)
    let line = flux#line(self.lines[self.t])
    let fmatch = matchlist(line,s:rgex.proj.file)
    let tmatch = matchlist(line,s:rgex.proj.term)
    if (match(line,s:rgex.proj.tabs)+1)||
     \ (flux#stop(line))||
     \ (1+match(line,'^\s*--'))
      break
    elseif !empty(fmatch) && fmatch[1] != '-'
      let self.match = fmatch
      call add(node.list,self.file())
    elseif !empty(tmatch) && tmatch[1] != '-'
      let self.match = tmatch
      call add(node.list,self.term())
    endif
  endfor

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
