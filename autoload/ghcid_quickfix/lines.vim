" Returns v:true if a:line matches '^Reloading\.\.\.'.
" Or returns v:false.
function! ghcid_quickfix#lines#match_reloading(line) abort
  return match(a:line, '^Reloading\.\.\.') isnot -1
endfunction

" Returns v:true if a:line matches '^All good.*'.
" Or returns v:false.
function! ghcid_quickfix#lines#match_all_good(line) abort
  return match(a:line, '^All good.*') isnot -1
endfunction

" Returns v:true if a:line matches 'error:'.
" Or returns v:false.
function! ghcid_quickfix#lines#match_error(line) abort
  return match(a:line, 'error:') isnot -1
endfunction

" Returns v:true if a:line matches 'warning:'.
" Or returns v:false.
function! ghcid_quickfix#lines#match_warning(line) abort
  return match(a:line, 'warning:') isnot -1
endfunction

" Returns v:true if a:line matches '^No files loaded, GHCi is not working properly\.$'.
" Or returns v:false.
function! ghcid_quickfix#lines#match_no_files_loaded(line) abort
  return match(a:line, '^No files loaded, GHCi is not working properly\.$') isnot -1
endfunction
