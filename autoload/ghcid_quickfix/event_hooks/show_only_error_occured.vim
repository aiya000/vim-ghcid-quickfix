" Please see `ghcid_quickfix#event_hooks#default#new` for what is made by this.
function! ghcid_quickfix#event_hooks#show_only_error_occured#new(qf_bufnr) abort
  let instance = {
    \ 'qf_bufnr': a:qf_bufnr,
  \ }

  function! instance.on_quickfix_buffer_created() abort dict
    echomsg 'ghcid-quickfix started.'
  endfunction

  function! instance.on_outputting_line(line) abort dict
    if ghcid_quickfix#lines#match_reloading(a:line)
      call setqflist([])
      call setbufvar(self.qf_bufnr, '&filetype', 'ghcid_quickfix')
    elseif ghcid_quickfix#lines#match_all_good(a:line)
      cclose
      echomsg 'All good'
    elseif ghcid_quickfix#lines#match_warning(a:line)
      cclose
      echomsg 'Compiled with warnings'
    elseif ghcid_quickfix#lines#match_error(a:line)
      copen
      wincmd p
    endif
  endfunction

  return instance
endfunction
