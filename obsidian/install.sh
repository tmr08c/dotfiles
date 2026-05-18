#!/usr/bin/env bash
#
# Set up the Obsidian vaults parent directory:
#   - Symlink ~/Documents/obsidian -> iCloud Obsidian container
#   - Attach a single git repo at the parent (one repo for all vaults)
#   - Exclude .git from iCloud sync via the Apple fileprovider xattr
#
# Idempotent: safe to re-run. Each step skips work that's already done.
# Network/auth failures during fetch are tolerated — local setup completes
# either way, so a fresh machine without SSH keys still gets a working repo.
#
# Prereqs:
#   - Obsidian.app installed (Brewfile cask handles this) so the iCloud
#     container exists
#   - iCloud signed in and the container has finished initial sync
#   - For fetch to succeed: SSH key registered with GitHub
#   - From the source machine: `git push` before switching machines

set -e

ICLOUD_CONTAINER="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
SYMLINK_PATH="$HOME/Documents/obsidian"
REMOTE_URL="git@github.com:tmr08c/obsidian-vaults.git"

# 1. Verify the iCloud container exists
if [ ! -d "$ICLOUD_CONTAINER" ]; then
  echo "iCloud Obsidian container not found at: $ICLOUD_CONTAINER" >&2
  echo "  - Is Obsidian.app installed? (brew bundle should handle this)" >&2
  echo "  - Has Obsidian been launched at least once?" >&2
  echo "  - iCloud may not have downloaded the container yet. To find it" >&2
  echo "    and force-download via Finder:" >&2
  echo "      open \$HOME/Library/Mobile\\ Documents" >&2
  echo "    locate 'iCloud~md~obsidian', right-click -> Download Now" >&2
  echo "    (or Keep Downloaded to also prevent future eviction)" >&2
  exit 1
fi

# 2. Create ~/Documents/obsidian symlink
mkdir -p "$(dirname "$SYMLINK_PATH")"

if [ -L "$SYMLINK_PATH" ]; then
  current_target=$(readlink "$SYMLINK_PATH")
  if [ "$current_target" = "$ICLOUD_CONTAINER" ]; then
    echo "symlink ok: $SYMLINK_PATH -> $ICLOUD_CONTAINER"
  else
    echo "symlink at $SYMLINK_PATH points to $current_target (expected $ICLOUD_CONTAINER)" >&2
    echo "  remove it manually and re-run if you want to replace it" >&2
    exit 1
  fi
elif [ -e "$SYMLINK_PATH" ]; then
  echo "$SYMLINK_PATH exists and is not a symlink; refusing to overwrite" >&2
  exit 1
else
  ln -s "$ICLOUD_CONTAINER" "$SYMLINK_PATH"
  echo "symlink created: $SYMLINK_PATH -> $ICLOUD_CONTAINER"
fi

# 3. Attach git at the parent if not already present
if [ -e "$ICLOUD_CONTAINER/.git" ]; then
  echo "git already attached at $ICLOUD_CONTAINER/.git"
else
  echo "attaching .git at $ICLOUD_CONTAINER..."
  (
    cd "$ICLOUD_CONTAINER"

    # Create .git and mark it iCloud-ignored BEFORE populating it. Without
    # this the file provider scans the freshly-init'd .git and produces a
    # ".git 2/" sync conflict, leaving the original .git half-populated.
    mkdir .git
    xattr -w com.apple.fileprovider.ignore#P 1 .git

    git init -q
    git remote add origin "$REMOTE_URL"

    # Best-effort fetch. If SSH/network isn't ready (fresh machine, no key
    # registered with GitHub yet), continue without checkout — user can
    # finish with `git fetch && git checkout main` later.
    if git fetch origin --quiet 2>/dev/null; then
      default_branch=$(git remote show origin 2>/dev/null \
        | awk '/HEAD branch/ {print $NF}')
      # Empty remote returns "(unknown)" — treat that as no default.
      if [ -z "$default_branch" ] || [ "$default_branch" = "(unknown)" ]; then
        default_branch=main
      fi

      if git rev-parse --verify "origin/$default_branch" >/dev/null 2>&1; then
        # Force-checkout: remote wins. User pushed from source before switching.
        git checkout -f -B "$default_branch" "origin/$default_branch" --quiet
        echo "git attached and synced from origin/$default_branch"
      else
        git symbolic-ref HEAD "refs/heads/$default_branch"
        echo "git attached (remote is empty; first commit will create $default_branch)"
      fi
    else
      echo "git initialized + remote configured, but fetch failed"
      echo "  (likely missing SSH key on GitHub — finish later with:"
      echo "     cd $SYMLINK_PATH && git fetch && git checkout main)"
    fi
  )
fi

# 4. Ensure the iCloud-ignore xattr is set on .git (idempotent; safe to re-apply)
if [ -d "$ICLOUD_CONTAINER/.git" ]; then
  xattr -w com.apple.fileprovider.ignore#P 1 "$ICLOUD_CONTAINER/.git"
  echo "iCloud-ignore xattr set on .git"
fi

echo "obsidian vaults ready at $SYMLINK_PATH"
echo ""
echo "  one-time manual step on this machine:"
echo "    Finder: right-click $SYMLINK_PATH -> Keep Downloaded"
echo "    (no reliable CLI equivalent; prevents iCloud from evicting vault files)"
