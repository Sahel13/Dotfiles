typeset -U path PATH
path=(
  ~/.local/bin
  ~/Misc/texlive/2025/bin/x86_64-linux
  ~/Misc/juliaup/bin
  ~/.ghcup/bin
  ~/.cabal/bin
  ~/opt/cuda/bin
  ~/.config/emacs/bin
  ~/.bun/bin
  $path
)
export PATH

# For consistent font sizes in alacritty across terminals. From:
# https://wiki.archlinux.org/title/Alacritty#Different_font_size_on_multiple_monitors
# https://github.com/alacritty/alacritty/issues/5101
export WINIT_X11_SCALE_FACTOR=1

export ZDOTDIR="$HOME/.config/zsh"
