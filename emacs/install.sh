#!/usr/bin/env bash
# Set up DOOM emacs
#
# Doom itself is a plain clone in ~/.config/emacs (not part of this repo); only
# the personal config in doom.d.symlink (-> ~/.doom.d) is tracked here. The
# Doom commit is pinned in emacs/doom-version so every machine runs the same
# version. To upgrade:
#
#   doom upgrade
#   git -C ~/.config/emacs rev-parse HEAD > ~/.dotfiles/emacs/doom-version
#
# and commit the new pin.
EMACS_DIR="$HOME/.config/emacs"
DOOM_VERSION=$(cat "$(dirname "$0")/doom-version")

if [ ! -d "$EMACS_DIR" ]; then
  git clone https://github.com/doomemacs/core "$EMACS_DIR"
  git -C "$EMACS_DIR" checkout --quiet "$DOOM_VERSION"
fi

current=$(git -C "$EMACS_DIR" rev-parse HEAD)
if [ "$current" != "$DOOM_VERSION" ]; then
  git -C "$EMACS_DIR" cat-file -e "$DOOM_VERSION^{commit}" 2>/dev/null ||
    git -C "$EMACS_DIR" fetch origin
  if git -C "$EMACS_DIR" merge-base --is-ancestor "$DOOM_VERSION" "$current"; then
    # Don't undo a local `doom upgrade`; the pin just needs bumping
    echo "Doom ($current) is newer than emacs/doom-version; update the pin"
  else
    git -C "$EMACS_DIR" checkout --quiet "$DOOM_VERSION"
  fi
fi

# Capture shell PATH and env vars so Emacs can find tools (elixir, node, etc.)
"$EMACS_DIR/bin/doom" env

# --force suppresses prompts (e.g. rebuild confirmation after Emacs version change)
"$EMACS_DIR/bin/doom" sync --force

# Install nerd-icons fonts. doom install no longer handles this automatically.
NERD_ICONS_PATH=$(ls -d "$EMACS_DIR"/.local/straight/build-*/nerd-icons 2>/dev/null | head -1)
if [ -n "$NERD_ICONS_PATH" ]; then
  emacs --batch \
    --eval "(add-to-list 'load-path \"$NERD_ICONS_PATH\")" \
    --eval "(require 'nerd-icons)" \
    --eval "(nerd-icons-install-fonts t)"
fi

exit 0
