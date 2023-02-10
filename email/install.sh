#!/usr/bin/env sh

#
# Email
#
# Set up capabilitie for local email manage with `mu` and `isync`
#

echo "Running mail install"

if test ! $(which mbsync) && test ! $(which mu); then
    echo "'mu' and 'mbsync' are not installed. Syncing with Brewfile."
    brew bundle --global
fi

echo "    Running mbsync…"
[ ! -d "$HOME/.mail/personal" ] && mkdir -p ~/.mail/personal
mbsync --all

echo "    Initalizing mu…"
mu init --maildir ~/.mail/personal --my-address tmr08c@gmail.com
mu index

exit 0
