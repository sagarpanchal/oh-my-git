# shellcheck disable=SC2148,SC2120

# Name: oh-my-git
# Author: Sagar Panchal (panchal.sagar@outlook.com)
# Permission to copy and modify is granted under the BSD license

sagar-bash-complete() {
  # shellcheck disable=SC2207
  COMPREPLY=($(compgen -W "${2//$'\n'/ }" -- "$1"))
}

kill-by-port() {
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

local-ip-v4() {
  ifconfig | grep "inet 19" | awk "{ print \$2 }"
}

local-ip-v6() {
  ifconfig | grep "inet6 f" | awk "{ print \$2 }"
}

git-remotes() {
  git remote
}

git-branches() {
  git --no-pager branch --format='%(refname:short)'
}

git-current-branch() {
  git rev-parse --abbrev-ref HEAD
}

git-fetch-ref() {
  local _remote=$2
  [[ -z "$_remote" ]] && _remote="origin"

  git fetch "$_remote" "refs/heads/$1*:refs/remotes/origin/$1*"
}

git-get() {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git fetch "$_remote" "$_branch" &&
    git pull "$_remote" "$_branch" --no-edit
}
alias git-pull=git-get

git-set() {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git push -u "$_remote" "$_branch"
}
alias git-push=git-set

git-sync() {
  git-pull "$1" "$2" &&
    git-push "$1" "$2"
}

git-abort() {
  git merge --abort
  git cherry-pick --abort
}

git-reset() {
  local _branch=$1
  local _remote=$2
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  git fetch "$_remote" "$_branch" &&
    git reset --hard "$_remote"/"$_branch"
}

git-clean-all() {
  git-reset && git clean -df
}

git-gc() {
  git reflog expire --expire-unreachable=now --all &&
    git gc --aggressive --prune=now
}
