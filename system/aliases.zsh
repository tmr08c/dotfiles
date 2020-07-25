# exa overides for ls
if $(exa &>/dev/null)
then
  alias ls="exa -F"
  alias l="exa -l"
  alias ll="exa -la"
  alias la="exa -a"
fi

# `bat` override for `cat`
if $(type bat &>/dev/null)
then
  # BAT_THEME is set in light and dark mode functions
  alias cat="bat"
fi
