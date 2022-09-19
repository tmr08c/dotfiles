#!/usr/bin/env zsh

# Configuration for compiling Erlang with documentation that I can use in IEx.
#
# See  https://github.com/asdf-vm/asdf-erlang#getting-erlang-documentation for
# more details
export KERL_BUILD_DOCS=yes
export KERL_INSTALL_HTMLDOCS=no
export KERL_INSTALL_MANDOCS=no

# Enable history in IEx
# https://blog.appsignal.com/2021/11/30/three-ways-to-debug-code-in-elixir.html
export ERL_AFLAGS="-kernel shell_history enabled"
