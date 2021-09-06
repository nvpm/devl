fu! s:show(...) "{
  let [tree] = a:000

  "let tree = s:{synx}.tree

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

so plug/flux/autoload/flux.vim

so plug/proj/autoload/proj.vim
so plug/proj/plugin/proj.vim

Proj proj

call s:show(proj.tree)

fu! NVPMTestTimer(timer)
  normal :<c-l><cr>
endf

call timer_start(NVPMTEST_timer_delay,'NVPMTestTimer')

