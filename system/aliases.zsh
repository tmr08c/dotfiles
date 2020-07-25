# exa overides for ls
if $(exa &>/dev/null)
then
  alias l="exa"
  alias ls="exa"
  alias ll="exa -la"
  alias la="exa -a"
  alias tree="exa --tree"
fi

# `bat` override for `cat`
if $(type bat &>/dev/null)
then
  # BAT_THEME is set in light and dark mode functions
  alias cat="bat"
fi
