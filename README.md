# :gift: vim-ghcid-quickfix :gift:

- - -

Increse your Haskell development via [ghcid](https://github.com/ndmitchell/ghcid)!

- - -

This allows to open ghcid as the quickfix buffer, by `:GhcidQuickfixStart`.

When you edited a .hs, it reloads automatically!

![](./sample.gif)

You can read compile errors/warnings by about 1sec.

## :grey_exclamation: Requirements :grey_exclamation:

- Vim 8.0 or later with `+terminal`
- ghcid to your `$PATH`

## :dizzy: How to install :dizzy:

### No package manager

clone this repo into `$MYVIMRC/pack/haskell/start/`

### dein.nvim

```haskell
call dein#add('aiya000/vim-ghcid-quickfix')
```

### dein.nvim with toml

```toml
[[plugins]]
repo = 'aiya000/vim-ghcid-quickfix'
```

## Configuration

Auto open QuickFix window upon errors (default: `'quickfix_on_start'`):

```vim
let g:ghcid_quickfix_showing = 'quickfix_on_error'
```
