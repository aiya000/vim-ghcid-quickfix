let s:V = vital#ghcid_quickfix#new()

let s:Msg = s:V.import('Vim.Message')

" Please see `ghcid_quickfix#start()`
let s:TERM_BUFFER_NAME = 'term-vim-ghcid-quickfix-ghcid' | lockvar s:TERM_BUFFER_NAME
let s:OUTPUT_BUFFER_NAME = 'output-vim-ghcid-quickfix-ghcid' | lockvar s:OUTPUT_BUFFER_NAME

function! ghcid_quickfix#start(make_new_event_hooks, args) abort
  call setqflist([])
  if s:is_ghcid_quickfix_already_ran()
    call ghcid_quickfix#stop()
  endif

  let qf_bufnr = s:make_a_ghcid_quickfix_buffer()
  let output_bufnr = s:make_new_scratch_buffer()  " Writing `output_bufnr` removes a dependency to the terminal buffer. e.g. This avoids unintended line spliting.
  let event_hooks = a:make_new_event_hooks(qf_bufnr)

  call event_hooks.on_quickfix_buffer_created()

  let ghcid = empty(a:args)
    \ ? 'ghcid'
    \ : 'ghcid ' . a:args

  let s:opts = {
    \ 'out_io': 'buffer',
    \ 'err_io': 'buffer',
    \ 'out_buf': output_bufnr,
    \ 'err_buf': output_bufnr,
    \ 'out_cb': function('s:caddexpr_lines_and_may_refresh', [event_hooks]),
    \ 'err_cb': function('s:caddexpr_lines_and_may_refresh', [event_hooks]),
    \ 'hidden': v:true,
    \ 'term_kill': 'term',
    \ 'term_name': s:TERM_BUFFER_NAME,
  \ } 

  if has('nvim') 
    call termopen(ghcid, s:opts)
  else
    call term_start(ghcid, s:opts)
  endif
endfunction

function! s:is_ghcid_quickfix_already_ran() abort
  return bufname(s:TERM_BUFFER_NAME) !=# ''
    \ && bufname(s:OUTPUT_BUFFER_NAME) !=# ''
endfunction

" Make a already existent or ne quickfix buffer.
function! s:make_a_ghcid_quickfix_buffer() abort
  copen
  setf ghcid_quickfix
  let qf_bufnr = winbufnr('.')
  cclose  " At here, we don't want to open the quickfix window
  return qf_bufnr
endfunction

function! s:make_new_scratch_buffer() abort
  new

  try
    silent execute 'file' s:OUTPUT_BUFFER_NAME
  catch /E95/
    " Reopen
    execute 'bwipe!' s:OUTPUT_BUFFER_NAME
    execute 'file' s:OUTPUT_BUFFER_NAME
  endtry

  setl buftype=nofile
  let bufnr = winbufnr('.')
  quit
  return bufnr
endfunction

" Refresh qflist to empty if ghcid is reloading.
function! s:caddexpr_lines_and_may_refresh(event_hooks, channel, lines) abort
  for line in split(a:lines, "[\r\n]")
    call s:resolve_line(a:event_hooks, line)
  endfor
endfunction

function! s:resolve_line(event_hooks, line) abort
  let line = s:remove_escape_sequences(a:line)

  call a:event_hooks.on_outputting_line(line)
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
  let term_bufnr = bufnr(s:TERM_BUFFER_NAME)
  if term_bufnr is -1
    return
  endif

  call term_setkill(term_bufnr, 'term')
  execute 'bwipe!' term_bufnr

  let output_bufnr = bufnr(s:OUTPUT_BUFFER_NAME)
  if output_bufnr is -1
    call s:Msg.error(
      \ 'Illegal state.\n' ..
      \ "the buffer '" .. s:TERM_BUFFER_NAME .. "' was existent.\n" ..
      \ "But the buffer '" .. s:OUTPUT_BUFFER_NAME .. "' is not existent."
    \ )
  endif

  try
    execute 'bwipe' output_bufnr
  catch /E516/
    " skip this if already deleted
  endtry

  cclose
endfunction
