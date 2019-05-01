" Please see `ghcid_quickfix#start()`
let s:TERM_BUFFER_NAME = 'term-vim-ghcid-quickfix-ghcid' | lockvar s:TERM_BUFFER_NAME
let s:OUTPUT_BUFFER_NAME = 'output-vim-ghcid-quickfix-ghcid' | lockvar s:OUTPUT_BUFFER_NAME

function! ghcid_quickfix#start(args) abort
  call setqflist([])
  let qf_bufnr = s:open_new_ghcid_quickfix_buffer()
  let output_bufnr = s:make_new_scratch_buffer() " Writing `output_bufnr` removes a dependency to the terminal buffer. e.g. This avoids unintended line spliting.

  let ghcid = empty(a:args)
    \ ? 'ghcid'
    \ : 'ghcid ' . a:args
  call term_start(ghcid, {
    \ 'out_io': 'buffer',
    \ 'err_io': 'buffer',
    \ 'out_buf': output_bufnr,
    \ 'err_buf': output_bufnr,
    \ 'out_cb': function('s:caddexpr_lines_and_may_refresh', [qf_bufnr]),
    \ 'err_cb': function('s:caddexpr_lines_and_may_refresh', [qf_bufnr]),
    \ 'hidden': v:true,
    \ 'term_kill': 'term',
    \ 'term_name': s:TERM_BUFFER_NAME,
  \ })
endfunction

function! s:open_new_ghcid_quickfix_buffer() abort
  copen
  setf ghcid_quickfix
  return winbufnr('.')
endfunction

function! s:make_new_scratch_buffer() abort
  new
  execute 'file' s:OUTPUT_BUFFER_NAME
  setl buftype=nofile
  let bufnr = winbufnr('.')
  quit
  return bufnr
endfunction

function! s:refresh_ghcid_quickfix_buffer(qf_bufnr) abort
  call setqflist([])
  call setbufvar(a:qf_bufnr, '&filetype', 'ghcid_quickfix')
endfunction

" Refresh qflist to empty if ghcid is reloading.
function! s:caddexpr_lines_and_may_refresh(qf_bufnr, channel, lines) abort
  for line in split(a:lines, "[\r\n]")
    call s:caddexpr_line_and_may_refresh(a:qf_bufnr, line)
  endfor
endfunction

function! s:caddexpr_line_and_may_refresh(qf_bufnr, line) abort
    let line = s:remove_escape_sequences(a:line)
    if match(line, '^Reloading...') isnot -1
      call s:refresh_ghcid_quickfix_buffer(a:qf_bufnr)
    endif

    caddexpr line
endfunction

function! s:remove_escape_sequences(x) abort
  " TODO: what are these > \]0;4, , , 
  let sequences = [
    \ '\e[\(\d\+\)\?\(;\d\+\)*m',
    \ '\e[m',
    \ '\]\(\d\+\)\?\(;\d\+\)*',
    \ '',
    \ '',
    \ '',
  \ ]
  let pattern_to_remove = '\(' . join(sequences, '\|') . '\)'

  return substitute(a:x, pattern_to_remove, '', 'g')
endfunction


function! ghcid_quickfix#stop() abort
  let bufnr = bufnr(s:TERM_BUFFER_NAME)
  call term_setkill(bufnr, 'term')
  execute 'bdelete!' bufnr
  cclose
endfunction
