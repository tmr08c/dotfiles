#!/usr/bin/env sh

#
# Email
#
# Set up capabilitie for local email manage with `mu` and `isync`
#

# Check for Homebrew
if test ! $(which mu); then
    echo "  Installing Homebrew for you."

    # # Install the correct homebrew for each OS type
    # if test "$(uname)" = "Darwin"
    # then
    #   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
    # then
    #   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    # fi

else
    echo "'mu' and 'mbsync' are not installed. Run 'dot' to install via homebrew."
fi

echo "Running mail install"

[ ! -d "~/.mail/personal" ] && mkdir -p ~/.mail/personal

exit 0
