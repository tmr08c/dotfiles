#!/bin/sh

echo "Setting up mise"

tools="erlang elixir go java julia node python ruby rust zig"
for tool in $tools; do
    echo "Installing latest $tool"
    mise use --global "$tool@latest"
done

exit 0
