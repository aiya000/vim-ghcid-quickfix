# :gift: vim-ghcid-quickfix :gift:

- - -

Increse your Haskell development via [ghcid](https://github.com/ndmitchell/ghcid)!

- - -

This allows to open ghcid as the quickfix buffer, by `:GhcidQuickfixStart`.

**For both Vim and NeoVim.**

When you edited a .hs, it reloads automatically!

![](./sample.gif)

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

Auto open QuickFix window upon errors (default = 1):

```vim
g:ghcid_open_quickfix = 1
```
