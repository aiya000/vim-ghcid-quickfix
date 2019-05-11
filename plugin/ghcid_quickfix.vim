scriptencoding utf-8

if exists('g:loaded_ghcid_quickfix')
  finish
endif
let g:loaded_ghcid_quickfix = v:true

command! -bar -nargs=* GhcidQuickfixStart call ghcid_quickfix#start(function('s:make_new_event_hooks'), <q-args>)
command! -bar GhcidQuickfixStop call ghcid_quickfix#stop()

function! s:make_new_event_hooks(qf_bufnr) abort
  let show_only_error_occured = get(g:, 'ghcid_quickfix_show_only_error_occured', v:false)
  return show_only_error_occured
    \ ? ghcid_quickfix#event_hooks#show_only_error_occured#new(a:qf_bufnr)
    \ : ghcid_quickfix#event_hooks#default#new(a:qf_bufnr)
endfunction
