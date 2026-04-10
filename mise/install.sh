#!/bin/sh

if ! command -v mise > /dev/null 2>&1; then
    echo "mise not found, skipping setup"
    exit 0
fi

echo "Setting up mise"

tools="erlang elixir go java julia node python ruby rust zig"
for tool in $tools; do
    echo "Installing latest $tool"
    mise use --global "$tool@latest"
done

exit 0
