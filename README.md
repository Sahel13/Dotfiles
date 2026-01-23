# Dotfiles

Configuration files for various applications. These are managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Stow usage
Stow packages are organized in top-level folders (for example `nvim/`, `tmux/`).

Stow individual packages:
```sh
stow -t ~ nvim
stow -t ~ tmux
```

Stow everything:
```sh
stow -t ~ */
```

## Neovim
[lazy.nvim](https://github.com/folke/lazy.nvim) should install all packages upon opening Neovim. Language servers, linters and formatters need to be installed manually using [mason.nvim](https://github.com/williamboman/mason.nvim).
