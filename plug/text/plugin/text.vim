" plug/text.vim
" once {

if !NVPMTEST&&exists('TEXTPLUGLOAD')|finish|else|let TEXTPLUGLOAD=1|endif

" end-once}
" init {

let text = text#text()

" end-init}
" cmds {

command! -nargs=? -range TextJust <line1>,<line2>call text.just(<args>)

" end-cmds}
" acmd {

" end-acmd}
