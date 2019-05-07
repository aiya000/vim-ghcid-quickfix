# :gift: vim-ghcid-quickfix :gift:

- - -

Increse your Haskell development via [ghcid](https://github.com/ndmitchell/ghcid)!

- - -

This allows to open ghcid as the quickfix buffer, by `:GhcidQuickfixStart`.

When you edited a .hs, it reloads automatically!

![](./sample.gif)

# :grey_exclamation: Requirements :grey_exclamation:

- Vim 8.0 or later with `+terminal`

# :dizzy: How to install :dizzy:

dein.nvim

```haskell
call dein#add('aiya000/vim-ghcid-quickfix')
```

dein.nvim with toml

```toml
[[plugins]]
repo = 'aiya000/vim-ghcid-quickfix'
```

# Configuration

Auto open QuickFix window upon errors (default = v:true):

```vim
let g:ghcid_quickfix_show_only_error_occured = v:true
```
