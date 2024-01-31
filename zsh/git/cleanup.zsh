#!/usr/bin/env zsh

# @see https://blog.takanabe.tokyo/en/2020/04/remove-squash-merged-local-git-branches/

# gcl: git-cleanup-remote-and-local-branches
#
# Cleaning up remote and local branch is delivered as follows:
# 1. Prune remote branches when they are deleted or merged
# 2. Remove local branches when their remote branches are removed
# 3. Remove local branches when a master included squash and merge commits

function git_remove_merged_local_branch() {
  local main_branch=$(get_main_branch)
  if [[ -z "$main_branch" ]]; then
    echo "Main branch could not be determined." >&2
    return 1
  fi

  echo "Start removing out-dated local merged branches"
  # Exclude the main branch and any other branches you don't want to delete
  git branch --merged | egrep -v "(^\*|$main_branch)" | xargs -I % git branch -d %
  echo "Finish removing out-dated local merged branches"
}

function get_main_branch() {
  # Check if the remote exists
  if git remote show origin &>/dev/null; then
    # Remote exists, get the default branch from the remote
    git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
    return 0
  fi

  # Remote doesn't exist, check for common local branch names
  for branch in main master; do
    if git show-ref -q --verify "refs/heads/$branch"; then
      echo $branch
      return 0
    fi
  done

  # No remote and no recognizable main branch found
  echo "No remote and no recognizable main branch found." >&2
  return 1
}

# When we use `Squash and merge` on GitHub,
# `git branch --merged` cannot detect the squash-merged branches.
# As a result, git_remove_merged_local_branch() cannot clean up
# unused local branches. This function detects and removes local branches
# when remote branches are squash-merged.
#
# There is an edge case. If you add suggested commits on GitHub,
# the contents in local and remote are different. As a result,
# This clean up function cannot remove local squash-merged branch.
function git_remove_squash_merged_local_branch() {
  local main_branch=$(get_main_branch)
  if [[ -z "$main_branch" ]]; then
    echo "Main branch could not be determined." >&2
    return 1
  fi

  echo "Start removing out-dated local squash-merged branches based on $main_branch"
  git checkout -q "$main_branch" &&
    git for-each-ref refs/heads/ "--format=%(refname:short)" |
    while read branch; do
      ancestor=$(git merge-base "$main_branch" $branch) &&
        if [[ $(git cherry "$main_branch" $(git commit-tree $(git rev-parse "$branch^{tree}") -p $ancestor -m _)) == "-"* ]]; then
          git branch -D $branch
        fi
    done
  echo "Finish removing out-dated local squash-merged branches"
}

# Clean up remote and local branches
function gitcleanup() {
  echo "Start removing out-dated remote merged branches"
  git fetch --prune
  echo "Finish removing out-dated remote merged branches"
  git_remove_merged_local_branch
  git_remove_squash_merged_local_branch
}

## Frm OMZ

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall() {
  local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if [[ "$_commit" != "$(git rev-parse HEAD)" ]]; then
    git reset $_commit || return 1
  fi
}

# Warn if the current branch is a WIP
function work_in_progress() {
  command git -c log.showSignature=false log -n 1 2>/dev/null | grep -q -- "--wip--" && echo "WIP!!"
}

# Git root
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

alias gf='git fetch --prune --jobs=10'
alias gl='git pull'
