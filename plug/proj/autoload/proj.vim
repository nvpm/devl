




let s:proj = {}
let s:proj.curr = {}
let s:proj.line = {}
let s:proj.tree = {}

fu! s:proj.curr.init(...) "{
  let self.p = 0
  let self.w = 0
  let self.t = 0
  let self.b = 0
endf "}
fu! s:proj.curr.edit(...) "{
endf "}
fu! s:proj.curr.list(...) "{
endf "}
fu! s:proj.curr.item(...) "{
endf "}
fu! s:proj.curr.loop(...) "{
endf "}
fu! s:proj.curr.last(...) "{
endf "}

fu! s:proj.line.init(...) "{
endf "}
fu! s:proj.line.topl(...) "{
endf "}
fu! s:proj.line.botl(...) "{
endf "}
fu! s:proj.line.show(...) "{
endf "}
fu! s:proj.line.hide(...) "{
endf "}
fu! s:proj.line.swap(...) "{
endf "}

fu! proj#proj(...) "{
  call s:proj.curr.init()
  call s:proj.line.init()
  return s:proj
endf "}
fu! proj#load(...) "{
  let [file] = a:000
  let s:proj.file = '.nvpm/proj/'.file
  let s:proj.tree = flux#flux(s:proj.file,'proj')
  " Update Last Position
  call s:proj.curr.last()
  " Edit Current Buffer
  call s:proj.curr.edit()
  " Show Top and Bottom Lines
  call s:proj.line.show()
endf "}

finish

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
  let s:proj.curr.p = 0
  let s:proj.curr.w = 0
  let s:proj.curr.t = 0
  let s:proj.curr.b = 0
  return s:proj
endf "}
fu!   proj#proc(    ) "{

endf "}
fu!   proj#load(file) "{
  let s:proj.file = '.nvpm/proj/'.a:file
  call s:proj.load()
endf "}
