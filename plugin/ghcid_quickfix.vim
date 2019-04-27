scriptencoding utf-8

if exists('g:loaded_ghcid_quickfix')
  finish
endif
let g:loaded_ghcid_quickfix = v:true

command! -bar -nargs=* GhcidQuickfixStart call ghcid_quickfix#start(<q-args>)
