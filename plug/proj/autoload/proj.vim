let s:proj = {}
let s:proj.tree = {}

fu! s:proj.item(type) "{

  let p = self.p
  let w = self.w
  let t = self.t
  let b = self.b

  let item = (a:type=='p')?self.tree.list[p]:{}
  let item = (a:type=='w')?self.tree.list[p].list[w]:{}
  let item = (a:type=='t')?self.tree.list[p].list[w].list[t]:{}
  let item = (a:type=='b')?self.tree.list[p].list[w].list[t].list[b]:{}

  return item

endf "}
fu! s:proj.list(type) "{

  let p = self.p
  let w = self.w
  let t = self.t
  let b = self.b

  let list = (a:type=='p')?self.tree.list:{}
  let list = (a:type=='w')?self.tree.list[p].list:{}
  let list = (a:type=='t')?self.tree.list[p].list[w].list:{}
  let list = (a:type=='b')?self.tree.list[p].list[w].list[t].list:{}

  return list

endf "}
fu! s:proj.load(    ) "{

  let self.tree = flux#flux(self.file)
  call proj#proc()
  let self.loaded = 1

endf "}
fu! s:proj.buff(    ) "{

  let buff = self.item('b')

  if buff.type == 't'
    "let split = split(buff.root,':')
    "let buff.root = (len(split)>=1)?split[0]:''
    "let buff.comm = (len(split)>=2)?split[1]:''
    "let buff.root = empty(root)||empty(resolve(glob(root)))?'.':root
    "let buff.comm = empty(buff.comm)?$SHELL:buff.comm
    "exec 'edit term://'.buff.root.'//'.buff.comm
  else
    if !empty(buff.file)
      exec 'edit '.buff.file
    elseif !empty(buff.name) && empty(buff.file)
      exec 'edit '.buff.name
    else
      exec 'edit .nvpm/null'
    endif
  endif

endf "}
fu!   proj#proj(    ) "{
  let s:proj.p = 0
  let s:proj.w = 0
  let s:proj.t = 0
  let s:proj.b = 0
  return s:proj
endf "}
fu!   proj#proc(    ) "{

endf "}
fu!   proj#load(file) "{
  let s:proj.file = '.nvpm/proj/'.a:file
  call s:proj.load()
endf "}
