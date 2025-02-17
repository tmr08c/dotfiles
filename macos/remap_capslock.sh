#!/usr/bin/env sh

# Remap Caps Lock to Left Control using hidutil.
# This requires macOS 10.13 or later.
# Author: ChatGPT

# Check if hidutil is available
if ! command -v hidutil &> /dev/null; then
    echo "Error: hidutil is not available. Please upgrade to macOS 10.13 or later."
    exit 1
fi

# Remap Caps Lock (0x700000039) to Left Control (0x7000000E0)
hidutil property --set '{
    "UserKeyMapping": [
        {
            "HIDKeyboardModifierMappingSrc": 0x700000039,
            "HIDKeyboardModifierMappingDst": 0x7000000E0
        }
    ]
}' &> /dev/null
