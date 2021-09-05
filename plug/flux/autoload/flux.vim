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
let s:proj.rgex.tabs='^\s*\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:proj.rgex.file='^\s*\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:proj.rgex.term='^\s*\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'
fu! s:proj.load() "{

  let tree = {}

  let self.linesnr = len(self.lines)

  if self.linesnr

    let tree.name = fnamemodify(self.orig,':t')
    let tree.root = './'
    let tree.list = []
    let tree.last = 0
    let proj = 0

    let i = 0

    while i < self.linesnr
      let line = flux#line(self.lines[i])

      let i+=1
    endwhile

  endif

  let self.tree = tree
  return tree

endf "}
fu! s:proj.proj(root,i) "{

  let node = self.meta(a:root)
  let node.type = 'proj'

  let i = a:i+1
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
    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.wksp(root,i) "{

  let node = self.meta(a:root)
  let node.type = 'wksp'

  let i = a:i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if 1+match(line,'^---')|break|endif
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
fu! s:proj.tabs(root,i) "{

  let node = self.meta(a:root)
  let node.type = 'taby'

  let i = a:i+1
  while i < self.linesnr
    let line = flux#line(self.lines[i])
    if 1+match(line,'^---')|break|endif
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
fu! s:proj.file(root) "{

  let node = self.meta(a:root)
  let node.file = resolve(node.root)
  let node.type = 'file'
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
    let root = a:root.(!empty(a:root)?'/':'').root
  endif

  let node.name = name
  let node.comm = comm
  let node.root = empty(root)?'.':resolve(root)
  let node.type = 'term'

  return node

endf "}
fu! s:proj.meta(root) "{
  let node={}
  let split=split(self.match[2],'[:=]',1)
  let node.name=trim(split[0])
  let node.root = len(split)==1?'':trim(split[1])
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(self.match[2],':')
    let node.root = [a:root.'/'.node.root,node.root][empty(a:root)]
  endif
  ""let node.root = resolve(node.root)
  let node.list = []
  let node.last = 0
  return node
endf "}
fu! s:proj.type(line,node) "{
  return 1+match(a:line,self.rgex[a:node])
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
