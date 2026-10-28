autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

# Branch only; skips the dirty check since `git status` is slow in large repos
git_dirty() {
  [[ -n $prompt_git_branch ]] || return
  echo "on %{$fg_bold[yellow]%}$prompt_git_branch%{$reset_color%}"
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

# This assumes that you always have an origin named `origin`, and that you only
# care about one specific origin. If this is not the case, you might want to use
# `$git cherry -v @{upstream}` instead.
need_push () {
  if [[ -n $prompt_git_branch ]]
  then
    number=${#${(f)$($git cherry -v origin/$prompt_git_branch 2>/dev/null)}}

    if [[ $number == 0 ]]
    then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

battery_status() {
  if test ! "$(uname)" = "Darwin"
  then
    exit 0
  fi

  if [[ $(sysctl -n hw.model) == *"Book"* ]]
  then
    $ZSH/bin/battery-status
  fi
}

export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push)\n› '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

# Find the current branch by reading .git/HEAD directly instead of running
# git, so the prompt costs nothing outside of repos. Handles worktrees and
# submodules, where `.git` is a file pointing at the real git dir.
set_prompt_git_branch() {
  local dir=$PWD gitdir head
  prompt_git_branch=
  while true; do
    if [[ -d $dir/.git ]]; then
      gitdir=$dir/.git
      break
    elif [[ -f $dir/.git ]]; then
      gitdir=$(<$dir/.git)
      gitdir=${gitdir#gitdir: }
      [[ $gitdir == /* ]] || gitdir=$dir/$gitdir
      break
    fi
    [[ -z $dir ]] && return
    dir=${dir%/*}
  done
  [[ -r $gitdir/HEAD ]] || return
  head=$(<$gitdir/HEAD)
  [[ $head == "ref: refs/heads/"* ]] && prompt_git_branch=${head#ref: refs/heads/}
}

precmd() {
  # Look up the branch once per prompt; git_dirty and need_push both use it
  set_prompt_git_branch
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
