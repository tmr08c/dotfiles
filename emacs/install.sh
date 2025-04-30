#!/usr/bin/env bash
# Set up DOOM emacs

# Sometime the post-install linking doesn't work, so we can force the overwrite
# here just to be safe
brew link --overwrite emacs-plus@30

# Put Emacs into the Applications directory so we can launch in from Finder
osascript -e '
try
    tell application "Finder"
        if exists alias file "Emacs.app" of folder "Applications" of startup disk then
            delete alias file "Emacs.app" of folder "Applications" of startup disk
        end if
        make alias file to posix file "/opt/homebrew/opt/emacs-plus@30/Emacs.app" at posix file "/Applications" with properties {name:"Emacs.app"}
    end tell
end try
'

# Have Emacs managed by brew services to start up
brew services start d12frosted/emacs-plus/emacs-plus@30

# Install shouldn't do much since I already have my config set up. It's mainly here to run
# `all-the-icons-install-fonts`.
~/.emacs.d/bin/doom install --force
# Sync should do the heavy lifting of install and compiling packages.
~/.emacs.d/bin/doom sync

exit 0
