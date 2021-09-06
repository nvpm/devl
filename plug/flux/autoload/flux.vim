" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

let s:flux = {}
let s:flux.path = ''
let s:flux.synx = ''
let s:flux.file = []
let s:flux.leng = 0
let s:flux.match = []

" }
" publ {

let s:proj = {}
let s:proj.rgex = {}
let s:proj.rgex.name='^\(-*\)\s*\(name\)\s*\(.*\)'
let s:proj.rgex.root='^\(-*\)\s*\(root\)\s*\(.*\)'
let s:proj.rgex.proj='^\(-*\)\s*\%(layout\|project\|proj\|pj\)\s*\(.*\)'
let s:proj.rgex.wksp='^\(-*\)\s*\%(workplace\|workspace\|area\|ws\)\s*\(.*\)'
let s:proj.rgex.slot='^\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:proj.rgex.file='^\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:proj.rgex.term='^\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'
fu! s:proj.load(...) "{

  let tree = {}
  let rgex = s:{s:flux.synx}.rgex

  let tree.name = fnamemodify(s:flux.path,':t')
  let tree.root = './'
  let tree.list = []
  let tree.last = 0
  let find = self.zero()

  let i = 0

  while i < s:flux.leng
    let line = flux#line(s:flux.file[i])
    if 1+match(line,'^---')|break|endif
    let s:flux.match = matchlist(line,rgex.name)
    if !empty(s:flux.match)
      if s:flux.match[1] == '--'|break|endif
      if s:flux.match[1] != '-' |let tree.name = s:flux.match[3]|endif
    endif
    let s:flux.match = matchlist(line,rgex.root)
    if !empty(s:flux.match)
      if s:flux.match[1] == '--'|break|endif
      if s:flux.match[1] != '-' |let tree.root = s:flux.match[3]|endif
    endif
    if self.list(line,'proj',tree,[],i,find)|break|endif
    if self.list(line,'wksp',tree,['proj'],i,find)|break|endif
    if self.list(line,'slot',tree,['proj','wksp'],i,find)|break|endif
    if self.list(line,'file',tree,['proj','wksp','slot'],i,find)|break|endif
    if self.list(line,'term',tree,['proj','wksp','slot'],i,find)|break|endif
    let i+=1
  endwhile

  let self.tree = tree
  return tree

endf "}
fu! s:proj.proj(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'proj'

  let find = self.zero()

  let i = i+1
  while i < s:flux.leng
    let line = flux#line(s:flux.file[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'proj')|break|endif
    if self.list(line,'wksp',node,[],i,find)|break|endif
    if self.list(line,'slot',node,['wksp'],i,find)|break|endif
    if self.list(line,'file',node,['wksp','slot'],i,find)|break|endif
    if self.list(line,'term',node,['wksp','slot'],i,find)|break|endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.wksp(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'wksp'

  let find = self.zero()

  let i = i+1
  while i < s:flux.leng
    let line = flux#line(s:flux.file[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'wksp')|break|endif
    if self.list(line,'slot',node,[],i,find)|break|endif
    if self.list(line,'file',node,['slot'],i,find)|break|endif
    if self.list(line,'term',node,['slot'],i,find)|break|endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.slot(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.type = 'slot'

  let find = self.zero()

  let i = i+1
  while i < s:flux.leng
    let line = flux#line(s:flux.file[i])
    if 1+match(line,'^---')|break|endif
    if self.type(line,'slot')|break|endif
    if self.list(line,'file',node,[],i,find)|break|endif
    if self.list(line,'term',node,[],i,find)|break|endif
    let i+=1
  endwhile

  return node

endf "}
fu! s:proj.file(...) "{

  let [root,i] = a:000

  let node = self.meta(root)
  let node.file = resolve(node.root)
  let node.type = 'file'
  unlet node.root
  unlet node.last
  unlet node.list
  return node

endf "}
fu! s:proj.term(...) "{

  let [root,i] = a:000

  let node={}
  let split=split(s:flux.match[2],'@',1)
  let name = trim(get(split,0,''))
  let comm = trim(get(split,1,''))

  let split=split(name,'[:=]',1)

  let name = trim(get(split,0,''))
  let root = trim(get(split,1,''))

  if !empty(root)&&!(1+match(s:flux.match[2],'='))
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

  let rgex = s:{s:flux.synx}.rgex
  let foundupper = 0

  for u in upper
    let foundupper = foundupper||find[u]
  endfor

  let s:flux.match = matchlist(line,rgex[type])
  if !empty(s:flux.match) && !foundupper
    if s:flux.match[1] == '--'|return 1|endif
    if s:flux.match[1] != '-'
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
  let split=split(s:flux.match[2],'[:=]',1)
  let node.name=trim(split[0])
  let node.root = len(split)==1?'':trim(split[1])
  let node.root = empty(node.root)?'':node.root.'/'
  if 1+match(s:flux.match[2],':')
    let node.root = [root.'/'.node.root,node.root][empty(root)]
  endif
  let node.list = []
  let node.last = 0
  return node
endf "}
fu! s:proj.type(...) "{
  let [line,type] = a:000
  return 1+match(line,s:{s:flux.synx}.rgex[type])
endf "}
fu! s:proj.zero(...) "{
  let find = {}
  let find.proj = 0
  let find.wksp = 0
  let find.slot = 0
  let find.file = 0
  let find.term = 0
  return find
endf "}

" }
" flux {

fu! flux#flux(...) "{

  let [s:flux.path,s:flux.synx] = a:000

  let s:flux.file = []
  try
    let s:flux.file = readfile(s:flux.path)
    let s:flux.leng = len(s:flux.file)
  catch
    echon 'file: no such file "'.s:flux.path.'"'
  endtry
  if !empty(s:flux.file)|return s:{s:flux.synx}.load()|endif
  return {}

endf "}
fu! flux#line(...) "{
  let [line] = a:000
  let comment = match(line,'#')
  if 1+comment|let line = line[0:comment-1]|endif
  return trim(line)
endf "}

" }
