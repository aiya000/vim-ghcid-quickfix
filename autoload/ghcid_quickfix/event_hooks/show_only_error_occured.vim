" Please see `ghcid_quickfix#event_hooks#default#new` for what is made by this.
function! ghcid_quickfix#event_hooks#show_only_error_occured#new(qf_bufnr) abort
  let instance = {
    \ 'qf_bufnr': a:qf_bufnr,
  \ }

  function! instance.on_quickfix_buffer_created() abort dict
  endfunction

  function! instance.on_outputting_line(line) abort dict
    if match(a:line, '^Reloading\.\.\.') isnot -1
      call setqflist([])
      call setbufvar(self.qf_bufnr, '&filetype', 'ghcid_quickfix')
    elseif match(a:line, '^All good.*') isnot -1
      cclose
      echomsg 'All good'
    elseif match(a:line, 'error:') isnot -1
      copen
    endif
  endfunction

  return instance
endfunction
