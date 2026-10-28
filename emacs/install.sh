#!/usr/bin/env bash
# Set up DOOM emacs
#
# Doom itself is a plain clone in ~/.config/emacs (not part of this repo); only
# the personal config in doom.d.symlink (-> ~/.doom.d) is tracked here.
EMACS_DIR="$HOME/.config/emacs"

if [ ! -d "$EMACS_DIR" ]; then
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$EMACS_DIR"
fi

# Capture shell PATH and env vars so Emacs can find tools (elixir, node, etc.)
"$EMACS_DIR/bin/doom" env

# --force suppresses prompts (e.g. rebuild confirmation after Emacs version change)
# --rebuild unconditionally rebuilds all packages
"$EMACS_DIR/bin/doom" sync --force --rebuild

# Install nerd-icons fonts. doom install no longer handles this automatically.
NERD_ICONS_PATH=$(ls -d "$EMACS_DIR"/.local/straight/build-*/nerd-icons 2>/dev/null | head -1)
if [ -n "$NERD_ICONS_PATH" ]; then
  emacs --batch \
    --eval "(add-to-list 'load-path \"$NERD_ICONS_PATH\")" \
    --eval "(require 'nerd-icons)" \
    --eval "(nerd-icons-install-fonts t)"
fi

exit 0
