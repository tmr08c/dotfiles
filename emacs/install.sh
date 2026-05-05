#!/usr/bin/env bash
# Set up DOOM emacs

# Sometime the post-install linking doesn't work, so we can force the overwrite
# here just to be safe
brew link --overwrite emacs-plus@30

# Have Emacs managed by brew services to start up
brew services start d12frosted/emacs-plus/emacs-plus@30

# Install shouldn't do much since I already have my config set up. It's mainly here to run
# `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
~/.emacs.d/bin/doom sync

exit 0
