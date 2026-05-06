#!/usr/bin/env bash
# Set up DOOM emacs

~/.emacs.d/bin/doom install --force
# --force suppresses prompts (e.g. rebuild confirmation after Emacs version change)
# --rebuild unconditionally rebuilds all packages
~/.emacs.d/bin/doom sync --force --rebuild

# Install nerd-icons fonts. doom install no longer handles this automatically.
NERD_ICONS_PATH=$(ls -d ~/.emacs.d/.local/straight/build-*/nerd-icons 2>/dev/null | head -1)
if [ -n "$NERD_ICONS_PATH" ]; then
  emacs --batch \
    --eval "(add-to-list 'load-path \"$NERD_ICONS_PATH\")" \
    --eval "(require 'nerd-icons)" \
    --eval "(nerd-icons-install-fonts t)"
fi

exit 0
