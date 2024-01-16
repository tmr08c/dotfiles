#!/usr/bin/env bash
# Set up DOOM emacs

# Put Emacs into the Applications directory so we can launch in from Finder
osascript -e 'tell application "Finder" to make alias file to posix file "/opt/homebrew/opt/emacs-plus@29/Emacs.app" at POSIX file "/Applications"'

# Have Emacs managed by brew services to start up
brew services start d12frosted/emacs-plus/emacs-plus@29

# Install shouldn't do much since I already have my config set up. It's mainly here to run
# `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
~/.emacs.d/bin/doom sync
