#!/usr/bin/env bash
# Set up DOOM emacs

# Install shouldn't do much since I already have my config set up. It's mainly here to run
# `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
# --force suppresses prompts (e.g. rebuild confirmation after Emacs version change)
# --rebuild unconditionally rebuilds all packages
~/.emacs.d/bin/doom sync --force --rebuild

exit 0
