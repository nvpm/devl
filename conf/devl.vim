" My experimental seng filetype
autocmd BufRead *.sng,*.txt setlocal ft=seng spell spelllang=en,pt

hi NVPMTestPassed  guibg=#009900 guifg=#000000 gui=bold
hi NVPMTestFailed  guibg=#990000 guifg=#ffffff gui=bold
hi NVPMTestWarning guibg=none    guifg=#ff0000 gui=bold

let NVPMTEST = 1

nmap <silent><F1> <esc>:silent! wall<cr>:NVPMTest<cr>
imap <silent><F1> <esc>:silent! wall<cr>:NVPMTest<cr>

command! NVPMTest so test/init.vim

" proj {

let proj_projname = 1


" }
