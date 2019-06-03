" Please see `ghcid_quickfix#event_hooks#quickfix_on_start#new` for what is made by this.
function! ghcid_quickfix#event_hooks#popup_always#new(qf_bufnr) abort
  " next_popup_line: Instructs where the next line should shows at
  let instance = {
    \ 'qf_bufnr': a:qf_bufnr,
    \ 'next_popup_line': 1,
  \ }

  function! instance.on_quickfix_buffer_created() abort dict
    call self.popup_notification('ghcid-quickfix started.', {})
  endfunction

  function! instance.on_outputting_line(line) abort dict
    if a:line ==# ''
      return
    elseif ghcid_quickfix#lines#match_reloading(a:line)
      let self.next_popup_line = 1
    endif
    call self.popup_notification(a:line, {})
  endfunction

  function! instance.popup_notification(string, options) abort
    call popup_create(a:string, extend({
      \ 'maxwidth': strlen(a:string),
      \ 'line': self.next_popup_line,
      \ 'time': 3000,
      \ 'tab': -1,
      \ 'border': [],
    \ }, a:options))
    call self.countup_next_popup_line()
  endfunction

  " Count up `next_popup_line`, but reset it if it is too large.
  function! instance.countup_next_popup_line() abort
    let self.next_popup_line += 1
    if self.next_popup_line >= 50
      let self.next_popup_line = 1
    endif
  endfunction

  return instance
endfunction
