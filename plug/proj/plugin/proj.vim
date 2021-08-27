" plug/proj.vim
" once {

if !NVPMTEST&&exists('PROJPLUGLOAD')|finish|else|let PROJPLUGLOAD=1|endif

" end-once}
" init {

let proj = proj#proj()

" end-init}
" help {

fu! HELPPROJLOAD(a,l,p)
  let list = split(glob('.nvpm/proj/*'),"\n")
  for i in range(len(list))
    let list[i] = fnamemodify(list[i],":t")
  endfor
  let list = join(list,"\n")
  return list
endf

" end-help}
" cmds {

command!
\ -complete=custom,HELPPROJLOAD
\ -nargs=1
\ ProjLoad
\ call proj#load("<args>")

" end-cmds}
" acmd {

" end-acmd}

