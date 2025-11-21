# Git worktree completion with fzf integration

# Shell function wrapper for wt command that handles directory changes
wt() {
    # If no arguments provided, just show help (don't process as directory-changing command)
    if [[ $# -eq 0 ]]; then
        command wt
        return $?
    fi
    
    case "${1:-}" in
        new|checkout|visit)
            # For commands that should change directory, capture the output and execute it
            local output
            output=$(command wt "$@")
            local exit_code=$?
            
            # Only process output if there is any and the command succeeded
            if [[ $exit_code -eq 0 ]] && [[ -n "$output" ]]; then
                local last_line
                last_line=$(echo "$output" | tail -n 1)
                if [[ "$last_line" =~ ^cd ]]; then
                    # Print all output except the last line (which is the cd command)
                    # Use a safer approach to remove the last line
                    local line_count=$(echo "$output" | wc -l | tr -d ' ')
                    if [[ "$line_count" -gt 1 ]]; then
                        echo "$output" | sed '$d'  # Remove last line using sed
                    fi
                    # Execute the cd command
                    eval "$last_line"
                else
                    # No cd command found, just print all output
                    echo "$output"
                fi
            else
                # Command failed or no output, print any output that exists
                [[ -n "$output" ]] && echo "$output"
            fi
            
            return $exit_code
            ;;
        *)
            # For other commands, just pass through to the original script
            command wt "$@"
            ;;
    esac
}

# Standard zsh completion for wt command
_wt() {
    local -a commands
    commands=(
        'new:Create a new branch and worktree'
        'checkout:Create a worktree for an existing branch'
        'list:List all worktrees for the current project'
        'remove:Remove a worktree'
        'visit:Change directory to a worktree'
        'help:Show help message'
    )

    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        '1: :->command' \
        '*::arg:->args'

    case $state in
        command)
            _describe -t commands 'wt command' commands
            ;;
        args)
            case $line[1] in
                checkout)
                    # Provide branch completion
                    local branches
                    branches=(${(f)"$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|^origin/||' | sort -u)"})
                    if [[ -n "$branches" ]]; then
                        _describe -t branches 'branch' branches
                    fi
                    ;;
                remove|visit)
                    # Provide branch names from existing worktrees
                    local branches
                    branches=(${(f)"$(git worktree list --porcelain 2>/dev/null | grep "^branch" | sed 's/branch refs\/heads\///')"})
                    if [[ -n "$branches" ]]; then
                        _describe -t branches 'worktree branch' branches
                    fi
                    ;;
                new)
                    _message 'new branch name'
                    ;;
            esac
            ;;
    esac
}

# Register the completion function
compdef _wt wt

# FZF-powered interactive functions (inspired by fzf-git.sh)
# These can be called directly or integrated into keybindings

if command -v fzf >/dev/null 2>&1; then
    # Interactive branch selection for wt checkout
    __fzf_wt_checkout() {
        local branches
        branches=$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|^origin/||' | sort -u)
        
        if [[ -z "$branches" ]]; then
            echo "No branches found" >&2
            return 1
        fi
        
        echo "$branches" | fzf \
            --height=40% \
            --reverse \
            --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {} 2>/dev/null || echo "Remote branch (not fetched locally)"' \
            --preview-window=right:50% \
            --header="Select branch to checkout into worktree"
    }
    
    # Interactive worktree selection for wt remove
    __fzf_wt_remove() {
        # Get all worktrees (not just main)
        local worktrees
        worktrees=$(git worktree list | grep -v '(bare)' | tail -n +2)
        
        if [[ -z "$worktrees" ]]; then
            echo "No additional worktrees found" >&2
            return 1
        fi
        
        # Show worktree list with path and branch info
        echo "$worktrees" | fzf \
            --height=40% \
            --reverse \
            --preview 'echo "Path: {1}" && echo "Branch: {3}" && echo "---" && cd {1} && git status --short && echo "---" && ls -la | head -20' \
            --preview-window=right:50% \
            --header="Select worktree to remove" | awk '{print $1}'
    }
    
    # Interactive worktree selection for wt visit
    __fzf_wt_visit() {
        # Get all worktrees
        local worktrees
        worktrees=$(git worktree list | grep -v '(bare)')
        
        if [[ -z "$worktrees" ]]; then
            echo "No worktrees found" >&2
            return 1
        fi
        
        # Show worktree list with path and branch info
        echo "$worktrees" | fzf \
            --height=40% \
            --reverse \
            --preview 'echo "Path: {1}" && echo "Branch: {3}" && echo "---" && cd {1} && git status --short && echo "---" && ls -la | head -20' \
            --preview-window=right:50% \
            --header="Select worktree to visit" | awk '{print $1}'
    }
    
    # Widget functions for ZLE (Zsh Line Editor)
    fzf-wt-checkout-widget() {
        local selected
        selected=$(__fzf_wt_checkout)
        if [[ -n "$selected" ]]; then
            LBUFFER="${LBUFFER}${selected}"
        fi
        zle reset-prompt
    }
    
    fzf-wt-remove-widget() {
        local selected
        selected=$(__fzf_wt_remove)
        if [[ -n "$selected" ]]; then
            LBUFFER="${LBUFFER}${selected}"
        fi
        zle reset-prompt
    }
    
    fzf-wt-visit-widget() {
        local selected
        selected=$(__fzf_wt_visit)
        if [[ -n "$selected" ]]; then
            # Execute the cd command directly
            cd "$selected"
            zle accept-line
        fi
        zle reset-prompt
    }
    
    # Register widgets if in interactive zsh
    if [[ -n "$ZSH_VERSION" ]] && [[ $- == *i* ]]; then
        zle -N fzf-wt-checkout-widget
        zle -N fzf-wt-remove-widget
        zle -N fzf-wt-visit-widget
        
        # Optional: Bind to specific key combinations
        # Users can add these to their .zshrc if desired:
        # bindkey '^G^W' fzf-wt-checkout-widget  # Ctrl-G Ctrl-W for worktree checkout
        # bindkey '^G^X' fzf-wt-remove-widget   # Ctrl-G Ctrl-X for worktree remove
        # bindkey '^G^V' fzf-wt-visit-widget    # Ctrl-G Ctrl-V for worktree visit
    fi
fi