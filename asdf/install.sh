#!/bin/sh

echo "Setting up asdf"

mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"

array=(direnv erlang elixir golang java julia nodejs python ruby rust typos zig)
for lang in "${array[@]}"; do
    echo "Adding plugin for '$lang'"
    asdf plugin add $lang
    echo "Installing latest version of '$lang'"
    asdf install $lang latest
    asdf set --home $lang latest
done

exit 0;
