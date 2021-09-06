" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

" }
" publ {

let s:proj = {}
let s:proj.rgex = {}
let s:proj.rgex.name='^\s*\(-*\)\s*\(name\)\s*\(.*\)'
let s:proj.rgex.root='^\s*\(-*\)\s*\(root\)\s*\(.*\)'
let s:proj.rgex.proj='^\s*\(-*\)\s*\%(layout\|project\|proj\|pj\)\s*\(.*\)'
let s:proj.rgex.wksp='^\s*\(-*\)\s*\%(workplace\|workspace\|area\|ws\)\s*\(.*\)'
let s:proj.rgex.slot='^\s*\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:proj.rgex.file='^\s*\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:proj.rgex.term='^\s*\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'
fu! s:proj.load(...) "{

  let tree = {}

  let self.linesnr = len(self.lines)

  if self.linesnr

    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = './'
    let tree.list = []
    let tree.last = 0
    let find = {}
    let find.proj = 0
    let find.wksp = 0
    let find.slot = 0
    let find.file = 0
    let find.term = 0

    let i = 0

    while i < self.linesnr

      let line = flux#line(self.lines[i])

      if 1+match(line,'^---')|break|endif
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

      "if self.list(line,'proj',tree,[],i,find)|break|endif
      "if self.list(line,'wksp',tree,['proj'],i,find)|break|endif
      "if self.list(line,'slot',tree,['proj','wksp'],i,find)|break|endif
      "if self.list(line,'file',tree,['proj','wksp','slot'],i,find)|break|endif
      "if self.list(line,'term',tree,['proj','wksp','slot'],i,find)|break|endif

      let i+=1

    endwhile

  endif

  let self.tree = tree
  return tree

endf "}
fu! s:proj.proj(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'proj'

  let i = i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'proj')|break|endif

    let self.match = matchlist(line,self.rgex.wksp)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-'
        call add(node.list,self.wksp(node.root,i))
      endif
    endif

    "let self.match = matchlist(line,self.rgex.slot)
    "if !empty(self.match) && (!foundwksp)
      "if self.match[1] == '--'|break|endif
      "if self.match[1] != '-'
        "call add(node.list,self.slot(node.root,i))
      "endif
      "let foundslot = 1
      "let foundwksp = 0
    "endif
    "let self.match = matchlist(line,self.rgex.file)
    "if !empty(self.match) && (!foundwksp&&!foundslot)
      "if self.match[1] == '--'|break|endif
      "if self.match[1] != '-'
        "call add(node.list,self.file(node.root))
      "endif
      "let foundfile = 1
      "let foundslot = 0
      "let foundwksp = 0
    "endif
    "let self.match = matchlist(line,self.rgex.term)
    "if !empty(self.match) && (!foundwksp&&!foundslot)
      "if self.match[1] == '--'|break|endif
      "if self.match[1] != '-'
        "call add(node.list,self.term(node.root))
      "endif
      "let foundterm = 1
      "let foundslot = 0
      "let foundwksp = 0
    "endif

    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.wksp(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'wksp'

  let i = i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'wksp')|break|endif
    let self.match = matchlist(line,self.rgex.slot)
    if !empty(self.match)
      if self.match[1] == '--'|break|endif
      if self.match[1] != '-'
        call add(node.list,self.slot(node.root,i))
      endif
    endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.slot(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'slot'

  let i = i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'slot')|break|endif
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
fu! s:proj.file(...) "{

  let [root] = a:000

  let node = self.meta(root)
  let node.file = resolve(node.root)
  let node.type = 'file'
  unlet node.root
  unlet node.last
  unlet node.list
  return node

endf "}
fu! s:proj.term(...) "{

  let [root] = a:000

  let node={}
  let split=split(self.match[2],'@',1)
  let name = trim(get(split,0,''))
  let comm = trim(get(split,1,''))

  let split=split(name,'[:=]',1)

  let name = trim(get(split,0,''))
  let root = trim(get(split,1,''))

  if !empty(root)&&!(1+match(self.match[2],'='))
    let root = a:000[0].(!empty(a:000[0])?'/':'').root
  endif

  let node.name = name
  let node.comm = comm
  let node.root = empty(root)?'.':resolve(root)
  let node.type = 'term'

  return node

endf "}
fu! s:proj.list(...) "{

  let [line,type,node,upper,i,find] = a:000

  let foundupper = 0

  for u in upper
    let foundupper = foundupper||find[u]
  endfor

  let self.match = matchlist(line,self.rgex[type])
  if !empty(self.match) && !foundupper
    if self.match[1] == '--'|return 1|endif
    if self.match[1] != '-'
      call add(node.list,self[type](node.root,i))
    endif
    let find[type] = 1
    for u in upper
      let find[u] = 0
    endfor
  endif
  return 0

endf "}
fu! s:proj.meta(...) "{
  let [root] = a:000
  let node={}
  let split=split(self.match[2],'[:=]',1)
  let node.name=trim(split[0])
  let node.root = len(split)==1?'':trim(split[1])
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [root.'/'.node.root,node.root][empty(root)]
  endif
  ""let node.root = resolve(node.root)
  let node.list = []
  let node.last = 0
  return node
endf "}
fu! s:proj.type(...) "{
  let [line,node] = a:000
  return 1+match(line,self.rgex[node])
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
