" Please see `ghcid_quickfix#event_hooks#default#new` for what is made by this.
"
" At a "current interval"
" - Only echo 'All good' with "no errors" and "no warnings". Or
" - Only echo 'Compiled with warnings' with "no errors" and "one or more warnings". Or
" - Open the qf window with "one or more errors".
"
" a "current interval" means between `ghcid-quickfix started or reloaded` and `the compiling finished`.
function! ghcid_quickfix#event_hooks#show_only_error_occured#new(qf_bufnr) abort
  " has_current_warnings: Did one or more warnings found at the current interval
  let instance = {
    \ 'qf_bufnr': a:qf_bufnr,
    \ 'has_current_warnings': v:false,
  \ }

  function! instance.on_quickfix_buffer_created() abort dict
    echomsg 'ghcid-quickfix started.'
  endfunction

  function! instance.on_outputting_line(line) abort dict
    if ghcid_quickfix#lines#match_reloading(a:line)
      let self.has_current_warnings = v:false
      call setqflist([])
      call setbufvar(self.qf_bufnr, '&filetype', 'ghcid_quickfix')
    elseif ghcid_quickfix#lines#match_warning(a:line)
      let self.has_current_warnings = v:true
    elseif ghcid_quickfix#lines#match_error(a:line)
      copen
      wincmd p
    elseif ghcid_quickfix#lines#match_all_good(a:line)
      cclose
      echomsg 'All good'
    elseif ghcid_quickfix#lines#match_no_files_loaded(a:line)
      copen
      wincmd p
    endif
  endfunction

  return instance
endfunction
