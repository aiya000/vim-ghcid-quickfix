function! ghcid_quickfix#start(args) abort
  call setqflist([])
  copen | setf ghcid_quickfix

  let ghcid = empty(a:args)
    \ ? 'ghcid'
    \ : 'ghcid ' . a:args
  call term_start(ghcid, {
    \ 'out_cb': function('s:caddexpr_line'),
    \ 'hidden': v:true,
    \ 'term_kill': 'term',
  \ })
endfunction

function! s:caddexpr_line(channel, line) abort
  " TODO: what are these > \]0;4, , , 
  let meaningless_on_quickfix = [
    \ '\e[\d\+\(;\d\+\)*m',
    \ '\e[m',
    \ '',
    \ '\]0;4',
    \ '',
    \ '',
    \ '',
  \ ]
  let pattern_to_ignore = '\(' . join(meaningless_on_quickfix, '\|') . '\)'

  caddexpr substitute(a:line, pattern_to_ignore, '', 'g')
endfunction
