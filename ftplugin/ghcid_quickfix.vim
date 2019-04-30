scriptencoding utf-8

let b:undo_ftplugin = 'setl ' . join([
  \ 'errorformat<',
\ ])

let &errorformat = '%f:%l:%c:%m,%f:%l:%c-%n:%m'
