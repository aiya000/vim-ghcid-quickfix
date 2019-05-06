" Please see `ghcid_quickfix#start()`
let s:TERM_BUFFER_NAME = 'term-vim-ghcid-quickfix-ghcid' | lockvar s:TERM_BUFFER_NAME
let s:OUTPUT_BUFFER_NAME = 'output-vim-ghcid-quickfix-ghcid' | lockvar s:OUTPUT_BUFFER_NAME

function! ghcid_quickfix#start(args) abort
  call setqflist([])
  if s:is_ghcid_quickfix_already_ran()
    call ghcid_quickfix#stop()
  endif

  let qf_bufnr = s:new_ghcid_quickfix_buffer()
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

function! s:is_ghcid_quickfix_already_ran() abort
  return bufname(s:TERM_BUFFER_NAME) !=# ''
    \ && bufname(s:OUTPUT_BUFFER_NAME) !=# ''
endfunction

" Make a new quickfix buffer.
" Also open its window if the option is enabled.
function! s:new_ghcid_quickfix_buffer() abort
  copen
  setf ghcid_quickfix
  let qf_bufnr = winbufnr('.')

  if !g:ghcid_quickfix_show_only_error_occured
    cclose
  endif

  return qf_bufnr
endfunction

function! s:make_new_scratch_buffer() abort
  new

  try
    silent execute 'file' s:OUTPUT_BUFFER_NAME
  catch /E95/
    execute 'bdelete!' s:OUTPUT_BUFFER_NAME
    execute 'file' s:OUTPUT_BUFFER_NAME
  endtry

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
    call s:resolve_line(a:qf_bufnr, line)
  endfor
endfunction

function! s:resolve_line(qf_bufnr, line) abort
  let line = s:remove_escape_sequences(a:line)

  if match(line, '^Reloading...') isnot -1
    call s:refresh_ghcid_quickfix_buffer(a:qf_bufnr)
  endif

  if !g:ghcid_quickfix_show_only_error_occured
    call s:notify_for_result(line)
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

function! s:notify_for_result(line) abort
  if match(a:line, '^All good.*') isnot -1
    cclose
    echomsg 'All good'
  elseif match(a:line, 'error:') isnot -1
    copen
  endif
endfunction

function! ghcid_quickfix#stop() abort
  let term_bufnr = bufnr(s:TERM_BUFFER_NAME)
  call term_setkill(term_bufnr, 'term')
  execute 'bdelete!' term_bufnr

  let output_bufnr = bufnr(s:OUTPUT_BUFFER_NAME)
  try
    execute 'bdelete' output_bufnr
  catch /E516/
    " skip this if already deleted
  endtry

  cclose
endfunction
