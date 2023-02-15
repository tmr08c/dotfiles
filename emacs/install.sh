#!/usr/bin/env bash
# Set up DOOM emacs

# Install shouldn't do much since I already have my config set up. It'main here
# to run `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
~/.emacs.d/bin/doom sync
