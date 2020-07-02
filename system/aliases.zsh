# exa overides for ls
if $(exa &>/dev/null)
then
  alias ls="exa -F"
  alias l="exa -l"
  alias ll="exa -la"
  alias la="exa -a"
fi

# `cat`
if $(type bat &>/dev/null)
then
  # alias cat="bat""OneHalfLight"
  alias cat="bat --theme=\$(darkMode =~ 'dark' && echo default || echo ansi-light)"

fi
