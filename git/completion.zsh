# Git worktree completion with fzf integration

# Standard zsh completion for wt command
_wt() {
    local -a commands
    commands=(
        'new:Create a new branch and worktree'
        'checkout:Create a worktree for an existing branch'
        'list:List all worktrees for the current project'
        'remove:Remove a worktree'
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
                remove)
                    # Provide worktree completion
                    local project_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
                    local worktree_base="$HOME/.worktrees"
                    local project_dir="$worktree_base/$project_name"
                    
                    if [[ -d "$project_dir" ]]; then
                        local worktrees
                        worktrees=(${(f)"$(git worktree list --porcelain 2>/dev/null | grep "^worktree $project_dir" | cut -d' ' -f2- | sed "s|$project_dir/||")"})
                        if [[ -n "$worktrees" ]]; then
                            _describe -t worktrees 'worktree' worktrees
                        fi
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
        local project_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
        local project_dir="$HOME/.worktrees/$project_name"
        
        if [[ ! -d "$project_dir" ]]; then
            echo "No worktrees found for project '$project_name'" >&2
            return 1
        fi
        
        local worktrees
        worktrees=$(git worktree list --porcelain 2>/dev/null | grep "^worktree $project_dir" | cut -d' ' -f2- | sed "s|$project_dir/||")
        
        if [[ -z "$worktrees" ]]; then
            echo "No worktrees found for project '$project_name'" >&2
            return 1
        fi
        
        echo "$worktrees" | fzf \
            --height=40% \
            --reverse \
            --preview "echo 'Worktree: {}' && echo '---' && cd '$project_dir/{}' && git status --short && echo '---' && ls -la | head -20" \
            --preview-window=right:50% \
            --header="Select worktree to remove"
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
    
    # Register widgets if in interactive zsh
    if [[ -n "$ZSH_VERSION" ]] && [[ $- == *i* ]]; then
        zle -N fzf-wt-checkout-widget
        zle -N fzf-wt-remove-widget
        
        # Optional: Bind to specific key combinations
        # Users can add these to their .zshrc if desired:
        # bindkey '^G^W' fzf-wt-checkout-widget  # Ctrl-G Ctrl-W for worktree checkout
        # bindkey '^G^X' fzf-wt-remove-widget   # Ctrl-G Ctrl-X for worktree remove
    fi
fi

# Export functions for use in other scripts
export -f __fzf_wt_checkout __fzf_wt_remove 2>/dev/null || true