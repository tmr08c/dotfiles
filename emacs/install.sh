#!/usr/bin/env bash
# Set up DOOM emacs

# Overwrite macOS's default emacs our homebrew version
brew link --overwrite emacs

ln -s /opt/homebrew/opt/emacs-plus@29/Emacs.app /Applications

# Install shouldn't do much since I already have my config set up. It's mainly here to run
# `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
~/.emacs.d/bin/doom sync
