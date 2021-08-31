" proj {

  set termguicolors
  set hidden
  set showtabline=2
  set laststatus=2

  " Project options
  let g:nvpm_new_project_edit_mode = 1
  let g:nvpm_load_new_project      = 1

  " directory tree
  let g:nvpm_maketree = 1

  " Line options for use with colors
  let g:nvpm_line_closure       = 0
  let g:nvpm_line_innerspace    = 0
  let g:nvpm_line_show_projname = 1
  let g:nvpm_line_bottomright   = '%y%m ⬤ %l,%c/%P'
  let g:nvpm_line_bottomcenter  = ' ⬤ %{NVPMLINEFILENAME()}'
  let g:nvpm_line_git_info      = 1
  let g:nvpm_line_git_delayms   = 5000

  " Git Info Colors
  hi NVPMLineGitModified guifg=#aa4371 gui=bold
  hi NVPMLineGitStaged   guifg=#00ff00 gui=bold
  hi NVPMLineGitClean    guifg=#77aaaa gui=bold

  " Tab Colors
  hi NVPMLineTabs     guifg=#777777 gui=bold
  hi NVPMLineTabsSel  guibg=#333a5a guifg=#ffffff gui=bold
  hi NVPMLineTabsFill guibg=none
  " Buffer Colors
  hi link NVPMLineBuff     NVPMLineTabs
  hi link NVPMLineBuffSel  NVPMLineTabsSel
  hi link NVPMLineBuffFill NVPMLineTabsFill
  " Workspace Colors
  hi link NVPMLineWksp     NVPMLineTabs
  hi link NVPMLineWkspSel  NVPMLineTabsSel
  " Project File Name Colors
  hi NVPMLineProjSel   guifg=#000000 guibg=#007777

  nmap <silent><space>  :NVPMNext buffer<cr>
  nmap <silent>m<space> :NVPMPrev buffer<cr>
  nmap <silent><tab>    :NVPMNext tab<cr>
  nmap <silent>m<tab>   :NVPMPrev tab<cr>
  nmap <silent><c-n>    :NVPMNext workspace<cr>
  nmap <silent><BS>     :NVPMNext workspace<cr>
  nmap <silent><c-p>    :NVPMPrev workspace<cr>
  nmap <F7>             :NVPMLoadProject<space>
  nmap <F8>             :w<cr>:NVPMEditProjects<cr>
  imap <F8>        <esc>:w<cr>:NVPMEditProjects<cr>
  nmap <F9>             :NVPMSaveDefaultProject<space>
  nmap <F10>            :NVPMNewProject<space>
  nmap <silent>mt       :NVPMTerminal<cr>
  nmap <silent>ml       :NVPMLineSwap<cr>

" }
" zoom {

  let zoom_height = 23
  let zoom_width  = 80
  "let zoom_layout = 'left'
  let zoom_left   = 0
  let zoom_right  = 0

  nmap <silent>mn    :Zoom<cr>
  nmap <silent><F11> :Zoom<cr>

" }
" text {

  nmap mja vipo<esc>
           \vip:s/\s\+/ /g<cr>
           \vip:TextJust 35<cr>
           \0vip<c-v><esc>$<right>
           \vip>
           \:nohlsearch<cr>
  nmap mjj vipo<esc>
           \vip:s/\s\+/ /g<cr>
           \vip:TextJust 76<cr>
           \0vip<c-v><esc>$<right>
           \:nohlsearch<cr>
  nmap mj5 vip:TextJust 50<cr>
  nmap mj6 vip:TextJust 60<cr>
  nmap mj7 vip:TextJust 70<cr>

" }
