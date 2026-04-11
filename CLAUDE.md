# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a dotfiles repository for managing system configuration files, organized topically. Each technology/tool has its own directory with specific configurations:

- `asdf/` - Version manager configuration
- `bash/` - Bash shell configuration
- `bin/` - Executable scripts (added to PATH)
- `emacs/` - Doom Emacs configuration
- `git/` - Git configuration and aliases
- `homebrew/` - macOS package management
- `macos/` - macOS-specific settings
- `zsh/` - Zsh shell configuration (primary shell)

## Key Components

- Files ending in `.symlink` get symlinked to `$HOME` as hidden files
- Files ending in `.zsh` are automatically loaded into shell environments
- `path.zsh` files are loaded first to configure PATH
- `completion.zsh` files are loaded last for shell completions
- `install.sh` files run when executing `script/install`

## Common Commands

### Installation

```bash
# Clone and set up dotfiles
git clone --recurse-submodules https://github.com/tmr08c/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap

# Update dotfiles and system dependencies
bin/dot
```

### Editing Dotfiles

```bash
# Open dotfiles for editing
bin/dot -e
```

### Shell Management

```bash
# Reload shell configuration
reload!

# Navigate to project directories
c [project-name]
```

### Emacs

```bash
# Start Emacs 
emacs

# Run Doom Emacs commands (when installed)
doom sync  # Synchronize packages
doom doctor  # Check for problems
```

## Development Environment

The dotfiles provide an optimized development environment with:

1. **Shell**: Zsh with custom prompt showing git status
2. **Version Control**: Git with extensive aliases
3. **Editors**: 
   - Doom Emacs (primary editor)
   - Vim/Neovim
4. **Package Management**:
   - Homebrew for system packages
   - asdf for language versions
5. **Terminal Tools**:
   - fzf for fuzzy finding
   - exa for enhanced directory listings
   - bat for syntax-highlighted file viewing

## File Organization

The repository uses a modular approach where:

1. Each tool/technology has its own directory
2. Configuration is symlinked from ~/.dotfiles to $HOME
3. Shell functions and aliases are loaded automatically from topic directories

## Extension

To add new functionality:

1. Create a new topic directory for your tool/technology
2. Add `.zsh` files for shell integration
3. Add `.symlink` files for configurations that belong in $HOME
4. Add `install.sh` script if installation steps are needed