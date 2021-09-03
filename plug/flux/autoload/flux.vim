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

let s:temp = {}
let s:temp.rgex = {}
let s:temp.rgex.name='^\s*\(-*\)\s*\(name\)\s*\(.*\)'
let s:temp.rgex.root='^\s*\(-*\)\s*\(root\)\s*\(.*\)'
let s:temp.rgex.proj='^\s*\(-*\)\s*\%(layout\|project\|proj\|pj\)\s*\(.*\)'
let s:temp.rgex.wksp='^\s*\(-*\)\s*\%(workplace\|workspace\|area\|ws\)\s*\(.*\)'
let s:temp.rgex.tabs='^\s*\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:temp.rgex.file='^\s*\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:temp.rgex.term='^\s*\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'
fu! s:temp.init() "{

  let self.tree = {}

endf "}
fu! s:temp.load() "{

  let tree = {}

  let self.linesnr = len(self.lines)

  if self.linesnr

    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = './'
    let tree.list = []
    let tree.last = 0

    let i = 0

    while i < self.linesnr
      let line = flux#line(self.lines[i])

      let self.match = matchlist(line,self.rgex.name)
      if !empty(self.match)
        if self.match[1] == '--'|break|endif
        if self.match[1] != '-' |let tree.name = self.match[3]|endif
      endif
      let self.match = matchlist(line,self.rgex.root)
      if !empty(self.match)
        if self.match[1] == '--'|break|endif
        if self.match[1] != '-' |let tree.root = self.match[3]|endif
      endif
      let self.match = matchlist(line,self.rgex.proj)
      if !empty(self.match)
        if self.match[1] == '--'|break|endif
        if self.match[1] != '-' 
          call add(tree.list,self.proj(tree.root,i))
        endif
      endif

      let i+=1
    endwhile

  endif

  let self.tree = tree
  return tree

endf "}
fu! s:temp.proj(root,i) "{

  let node = self.meta(a:root)

  let i = a:i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if self.type(line,'proj')|break|endif
    let self.match = matchlist(line,self.rgex.wksp)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-' 
        call add(node.list,self.wksp(node.root,i))
      endif
    endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:temp.wksp(root,i) "{

  let node = self.meta(a:root)

  let i = a:i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if self.type(line,'wksp')|break|endif
    let self.match = matchlist(line,self.rgex.tabs)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-' 
        call add(node.list,self.tabs(node.root,i))
      endif
    endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:temp.tabs(root,i) "{

  let node = self.meta(a:root)

  let i = a:i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if self.type(line,'tabs')|break|endif
    let self.match = matchlist(line,self.rgex.file)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-' 
        call add(node.list,self.file(node.root))
      endif
    endif
    let self.match = matchlist(line,self.rgex.term)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-' 
        call add(node.list,self.term(node.root))
      endif
    endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:temp.file(root) "{

  let node = self.meta(a:root)
  let node.file = resolve(node.root)
  unlet node.root
  unlet node.last
  unlet node.list
  return node

endf "}
fu! s:temp.term(root) "{

  let node={}
  let split=split(self.match[2],'@',1)
  let name = trim(get(split,0,''))
  let comm = trim(get(split,1,''))

  let split=split(name,'[:=]',1)

  let name = trim(get(split,0,''))
  let root = trim(get(split,1,''))

  if !empty(root)&&!(1+match(self.match[2],'='))
    let root = a:root.'/'.root
  endif

  let node.name = name
  let node.comm = comm
  let node.root = empty(root)?'.':resolve(root)

  return node

endf "}
fu! s:temp.meta(root) "{
  let node={}
  let split=split(self.match[2],'[:=]',1)
  let node.name=trim(split[0])
  let node.root = len(split)==1?'':trim(split[1])
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  "let node.root = resolve(node.root)
  let node.list = []
  let node.last = 0
  return node
endf "}
fu! s:temp.type(line,node) "{
  return 1+match(a:line,self.rgex[a:node])
endf "}

let s:proj = {}

fu! s:proj.meta(root) "{
  let node={}
  let split=split(self.match[2],'[:=]',1)
  let node.name=trim(split[0])
  let node.root = len(split)==1?'':trim(split[1])
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  let node.root = resolve(node.root)
  let node.list = []
  let node.last = 0
  return node
endf "}
fu! s:proj.load() "{

  let tree = {}

  if !empty(self.lines)

    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = './'
    let tree.list = []
    let tree.last = 0
    let self.jump = 0
    let self.stop = 0

    let self.r = 0
    let self.linesnr = len(self.lines)

    while self.r < self.linesnr
      let line = flux#line(self.lines[self.r])

      if (1+match(line,'^---'))||(line=='--')
        break
      endif
      if line=='-'
        let self.jump = 1
        let self.r+=1
        continue
      endif

      let self.match=matchlist(line,s:rgex.proj.name)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.r+=1|continue|endif
        let tree.name = self.match[3]
      endif

      let self.match=matchlist(line,s:rgex.proj.root)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.r+=1|continue|endif
        let tree.root = self.match[3]
      endif

      let self.match=matchlist(line,s:rgex.proj.proj)
      if !empty(self.match)&&!self.jump
        if self.match[1] == '--'|break|endif
        if self.match[1] == '-' |let self.r+=1|continue|endif
        call add(tree.list,self.proj(tree.root))
      endif

      if self.stop|break|endif
      let self.jump = 0
      let self.r+=1
    endwhile

  endif
  let self.tree = tree
  return tree

endf "}
fu! s:proj.proj(root) "{

  let node = self.meta(a:root)

  let self.p = self.r+1
  while self.p < self.linesnr && !self.stop
    let line = flux#line(self.lines[self.p])
    if (1+match(line,'^---'))|let self.stop=1|break|endif
    if self.node(line,'proj')|break|endif
    if line=='-'
      while 1
        let self.p+=1
        let self.r+=1
        let line = flux#line(self.lines[self.p])
        if self.node(line,'wksp')|let self.p+=1|let self.r+=1|break|endif
      endwhile
      continue
    endif
    if 1+match(line,'^--')
      while 1
        let self.p+=1
        let self.r+=1
        let line = flux#line(self.lines[self.p])
        if self.node(line,'proj')|break|endif
      endwhile
      break
    endif
    let self.match = matchlist(line,s:rgex.proj.wksp)
    if !empty(self.match)
      if self.match[1]=='-'|let self.p+=1|let self.r+=1|continue|endif
      call add(node.list,self.wksp(node.root))
    endif
    let self.p+=1
  endwhile
  "let self.r = self.p-1

  return node

endf "}
fu! s:proj.wksp(root) "{

  let node = self.meta(a:root)

  let self.w = self.p+1
  while self.w < self.linesnr && !self.stop
    let line = flux#line(self.lines[self.w])
    if (1+match(line,'^---'))|let self.stop=1|break|endif
    if self.node(line,'wksp')|break|endif
    if line=='-'
      while 1
        let self.w+=1
        let self.p+=1
        let line = flux#line(self.lines[self.w])
        if self.node(line,'tabs')|let self.w+=1|let self.p+=1|break|endif
      endwhile
      continue
    endif
    if 1+match(line,'^--')
      while 1
        let self.w+=1
        let self.p+=1
        let line = flux#line(self.lines[self.w])
        if self.node(line,'wksp')|break|endif
      endwhile
      break
    endif
    let self.match = matchlist(line,s:rgex.proj.tabs)
    if !empty(self.match)
      if self.match[1]=='-'|let self.w+=1|let self.p+=1|continue|endif
      call add(node.list,self.tabs(node.root))
    endif
    let self.w+=1
  endwhile
  "let self.p = self.w-1

  return node
endf "}
fu! s:proj.tabs(root) "{

  let node = self.meta(a:root)

  let self.t = self.w+1
  while self.t < self.linesnr && !self.stop
    let line = flux#line(self.lines[self.t])
    if (1+match(line,'^---'))|let self.stop=1|break|endif
    if self.node(line,'tabs')|break|endif
    if line=='-'
      while 1
        let self.t+=1
        let self.w+=1
        let line = flux#line(self.lines[self.t])
        if self.node(line,'file')|let self.t+=1|let self.w+=1|break|endif
        if self.node(line,'term')|let self.t+=1|let self.w+=1|break|endif
      endwhile
      continue
    endif
    if 1+match(line,'^--')
      while 1
        let self.t+=1
        let self.w+=1
        let line = flux#line(self.lines[self.t])
        if self.node(line,'tabs')|break|endif
      endwhile
      break
    endif
    let self.match = matchlist(line,s:rgex.proj.file)
    if !empty(self.match)
      if self.match[1]=='-'|let self.t+=1|let self.w+=1|continue|endif
      call add(node.list,self.file(node.root))
    endif
    let self.match = matchlist(line,s:rgex.proj.term)
    if !empty(self.match)
      if self.match[1]=='-'|let self.t+=1|let self.w+=1|continue|endif
      call add(node.list,self.term(node.root))
    endif
    let self.t+=1
  endwhile
  "let self.p = self.w-1

  return node

endf "}
fu! s:proj.file(root) "{

  let node = self.meta(a:root)
  let node.file = node.root
  unlet node.root
  unlet node.last
  unlet node.list
  return node

endf "}
fu! s:proj.term(root) "{

  let node={}
  let split=split(self.match[2],'@',1)
  let name = trim(get(split,0,''))
  let comm = trim(get(split,1,''))

  let split=split(name,'[:=]',1)

  let name = trim(get(split,0,''))
  let root = trim(get(split,1,''))

  if !empty(root)&&!(1+match(self.match[2],'='))
    let root = a:root.'/'.root
  endif

  let node.name = name
  let node.comm = comm
  let node.root = empty(root)?'.':resolve(root)

  return node

endf "}
fu! s:proj.node(line,node) "{
  return 1+match(a:line,s:rgex.proj[a:node])
endf "}
fu! s:proj.eval() "{
endf "}

" }
" flux {

fu! flux#flux(...) "{

  let tree = {}
  if !empty(a:000)
    if len(a:000)==1||a:000[1]=='proj'
      let s:proj.orig = a:000[0]
      let s:proj.lines = file#read(s:proj.orig)
      if !empty(s:proj.lines)|let tree=s:proj.load()|endif
    elseif a:000[1]=='iris'
    elseif a:000[1]=='line'
    elseif a:000[1]=='imux'
    elseif a:000[1]=='temp'
      let s:temp.orig = a:000[0]
      let s:temp.lines = file#read(s:temp.orig)
      if !empty(s:temp.lines)|let tree=s:temp.load()|endif
    endif
  endif
  return tree

endf "}
fu! flux#line(line) "{
  let line = a:line
  let comment = match(line,'#')
  if 1+comment|let line = line[0:comment-1]|endif
  return trim(line)
endf "}
fu! flux#show(synx) "{

  let tree = s:{a:synx}.tree

  let name = get(tree,'name','')
  let root = resolve(get(tree,'root',''))
  if !empty(name) && !empty(root)
    echo '"name":"'.name.'"'
    echo '"root":"'.root.'"'
  endif

  if !empty(tree)
    if exists('tree.list')
      for proj in tree.list
        let name = get(proj,'name','')
        let root = resolve(get(proj,'root',''))
        echo '"'.name.'":"'.root.'"'
        if exists('proj.list')
          for wksp in proj.list
            let name = get(wksp,'name','')
            let root = resolve(get(wksp,'root',''))
            echo '  "'.name.'":"'.root.'"'
            if exists('wksp.list')
              for slot in wksp.list
                let name = get(slot,'name','')
                let root = resolve(get(slot,'root',''))
                echo '    "'.name.'":"'.root.'"'
                if exists('slot.list')
                  for buff in slot.list
                    echo '      '.string(buff)
                  endfor
                endif
              endfor
            endif
          endfor
        endif
      endfor
    endif
  endif

endf "}

" }
