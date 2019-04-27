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
  caddexpr substitute(a:line, '', '', 'g')
endfunction
