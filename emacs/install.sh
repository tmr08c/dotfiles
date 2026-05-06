#!/usr/bin/env bash
# Set up DOOM emacs

~/.emacs.d/bin/doom install --force
# --force suppresses prompts (e.g. rebuild confirmation after Emacs version change)
# --rebuild unconditionally rebuilds all packages
~/.emacs.d/bin/doom sync --force --rebuild

# Install nerd-icons fonts. doom install no longer handles this automatically.
emacs --batch \
  --eval "(add-to-list 'load-path \"$(echo ~/.emacs.d/.local/straight/build-*/nerd-icons)\")" \
  --eval "(require 'nerd-icons)" \
  --eval "(nerd-icons-install-fonts t)"

exit 0
