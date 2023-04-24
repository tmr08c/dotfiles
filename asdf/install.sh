#!/bin/sh

echo "Setting up asdf"

array=(direnv erlang elixir golang julia nodejs python ruby rust zig)
for lang in "${array[@]}"; do
    echo "Adding plugin for '$lang'"
    asdf plugin add $lang
    echo "Installing latest version of '$lang'"
    asdf install $lang latest
    asdf global $lang latest
done
