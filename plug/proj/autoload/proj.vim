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
fu!   proj#show(synx) "{

  let tree = s:proj.tree

  let name = get(tree,'name','')
  let root = get(tree,'root','')
  echo '"name":"'.name.'"'
  echo '"root":"'.root.'"'

  if !empty(tree)
    if exists('tree.list')
      for proj in tree.list
        let name = get(proj,'name','')
        let root = get(proj,'root','')
        echo '"'.name.'":"'.root.'"'
        if exists('proj.list')
          for wksp in proj.list
            let name = get(wksp,'name','')
            let root = get(wksp,'root','')
            echo '  "'.name.'":"'.root.'"'
            if exists('wksp.list')
              for slot in wksp.list
                let name = get(slot,'name','')
                let root = get(slot,'root','')
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





















finish

let g:proj = {}

"let g:proj.p = 0
"let g:proj.w = 0
"let g:proj.t = 0
"let g:proj.b = 0
let g:proj.file = ''
let g:proj.visible = 0
let g:proj.tree = {}

let s:user = {}
let s:user.git = ''
let s:user.visible      = 0
let s:user.bottomcenter = get(g:,'proj_bottomcenter'  ,' ⬤ %f'           )
let s:user.bottomright  = get(g:,'proj_bottomright'   ,'%y%m ⬤ %l,%c/%P' )
let s:user.closure      = get(g:,'proj_closure'       ,1   )
let s:user.projname     = get(g:,'proj_projname'      ,1   )
let s:user.gitinfo      = get(g:,'proj_git_info'      ,0   )
let s:user.gitdelayms   = get(g:,'proj_git_info_delay',2000)
let s:user.gittimer     = 0

let s:p = 0
let s:w = 0
let s:t = 0
let s:b = 0

fu! proj#item(type) "{

  let item = a:type=='p'?g:proj.tree.list[0]:{}
  let item = a:type=='w'?g:proj.tree.list[0].list[0]:{}
  let item = a:type=='t'?g:proj.tree.list[0].list[0].list[0]:{}
  let item = a:type=='b'?g:proj.tree.list[0].list[0].list[0].list[0]:{}

  return item

endf "}
fu! proj#list(type) "{

  let list = a:type=='p'?g:proj.tree.list:[]
  let list = a:type=='w'?g:proj.tree.list.list:[]
  let list = a:type=='t'?g:proj.tree.list.list.list:[]
  let list = a:type=='b'?g:proj.tree.list.list.list.list:[]

  return list


endf "}
fu! proj#load(file) "{

  let file = '.nvpm/proj/'.a:file
  let g:proj.tree = flux#flux(file)

  if !empty(g:proj.tree)
    let g:proj.file = file
    "call proj#buff()
    call proj#show()
    let g:proj.loaded = 1
  endif

endf "}
fu! proj#buff()     "{

  let buff = proj#item('b')

  if exists('buff.comm')
    if !empty(buff.comm)
      exec 'edit term://.//'.buff.comm
    elseif !empty(buff.name) && empty(buff.comm)
      exec 'edit term://.//'.buff.name
    else
      exec 'buffer|terminal'
    endif
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
fu! proj#topl()     "{

  let line    = ''
  let currproj = proj#item('p')
  let currwksp = proj#item('w')
  let currtab  = proj#item('t')

  for tab in proj#list('t')
    let iscurr = tab.name == currtab.name
    let line  .= '%#ProjTabs'
    let line  .= iscurr ? 'Sel#' : '#'
    let line  .= s:user.closure && iscurr ? '[' : ' '
    let line  .= tab.name
    let line  .= s:user.closure && iscurr ? ']' : ' '
  endfor

  let line .= '%#ProjTabsFill#'

  let workspaces = proj#list('w')
  let w = []

  for wksp in proj#list('w')
    let iscurr = wksp.name == currwksp.name
    let right = ''
    let right .= '%#ProjWksp'
    let right .= iscurr ? 'Sel#' : '#'
    let right .= s:user.closure && iscurr ? '[' : ' '
    let right .= wksp.name
    let right .= s:user.closure && iscurr ? ']' : ' '
    call add(w,right)
  endfor

  let line .= '%='
  let line .= join(reverse(w))

  "let line .= s:user.projname?'%#ProjProjSel#'.' '.currproj.name.' ':''

  return line

endf "}
fu! proj#botl()     "{

  let line  = ''

  let currbuf = proj#item('b')

  for buff in proj#list('b')
    let iscurr = buff.name == currbuf.name
    let line  .= '%#ProjBuff'
    let line  .= iscurr ? 'Sel#' : '#'
    let line  .= s:user.closure && iscurr ? '[' : ' '
    let line  .= buff.name
    let line  .= s:user.closure && iscurr ? ']' : ' '
  endfor

  "let line .= s:user.git
  let line .= '%#ProjBuffFill#'
  let line .= s:user.bottomcenter
  let line .= '%='
  let line .= s:user.bottomright

  return line

endf "}
fu! proj#show()     "{

  set tabline=%!proj#topl()
  "set statusline=%!proj#botl()
  "set showtabline=2
  "set laststatus=2
  let g:proj.visible = 1

endf "}
