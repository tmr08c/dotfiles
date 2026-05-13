#!/usr/bin/env bash
#
# Set repo-local git config for the dotfiles repo itself.
# Mostly tuned for the submodule workflow (e.g. Doom Emacs as a submodule):
# pulls recurse, status/diff surface submodule movement, push refuses to
# leave the superproject pointing at unpushed submodule commits.

set -e

cd "$(dirname "$0")/.."

git config --local submodule.recurse true
git config --local status.submoduleSummary true
git config --local diff.submodule log
git config --local fetch.recurseSubmodules on-demand
git config --local push.recurseSubmodules check
