# shellcheck disable=SC2148,SC2120

# Name: oh-my-git
# Author: Sagar Panchal (panchal.sagar@outlook.com)
# Permission to copy and modify is granted under the BSD license

function sagar-bash-complete {
  # shellcheck disable=SC2207
  COMPREPLY=($(compgen -W "${2//$'\n'/ }" -- "$1"))
}

function kill-by-port {
  local _pidList
  _pidList="$(lsof -t -i:"$1")"
  _pidList=${_pidList//$'\n'/ }

  if [ -n "$_pidList" ]; then
    eval "kill -9 $_pidList"
  else
    echo -e "No process found running on port - $1" >&2
    return
  fi
}

function local-ip-v4 {
  ifconfig | grep "inet 19" | awk "{ print \$2 }"
}

function local-ip-v6 {
  ifconfig | grep "inet6 f" | awk "{ print \$2 }"
}

function git-remotes {
  git remote
}

function git-branches {
  git --no-pager branch --format='%(refname:lstrip=2)'
}

function git-current-branch {
  git rev-parse --abbrev-ref HEAD
}

function git-fetch-ref {
  local _remote=$2
  [[ -z "$_remote" ]] && _remote="origin"

  git fetch "$_remote" "refs/heads/$1*:refs/remotes/origin/$1*"
}

function git-fetch {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git fetch "$_remote" "$_branch"
}

function git-pull {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git-fetch "$_branch" "$_remote" &&
    git pull "$_remote" "$_branch" --no-edit
}

function git-push {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git push -u "$_remote" "$_branch"
}

function git-sync {
  git-pull "$1" "$2" &&
    git-push "$1" "$2"
}

function git-abort {
  git merge --abort
  git cherry-pick --abort
}

function git-reset {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git-fetch "$_branch" "$_remote" &&
    git reset --hard "$_remote"/"$_branch"
}

function git-clean-all {
  git-reset &&
    git clean -df
}

function git-gc {
  git reflog expire --expire-unreachable=now --all &&
    git gc --aggressive --prune=now
}
