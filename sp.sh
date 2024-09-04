# shellcheck disable=SC2148,SC2120

# Name: oh-my-git
# Author: Sagar Panchal (panchal.sagar@outlook.com)
# Permission to copy and modify is granted under the BSD license

function sagar-bash-complete {
  # shellcheck disable=SC2207
  COMPREPLY=($(compgen -W "${2//$'\n'/ }" -- "$1"))
}

function os-impl-name {
  local _osImplName
  _osImplName="$(uname -s)"

  case "${_osImplName}" in
  Linux*) machine=Linux ;;
  Darwin*) machine=Mac ;;
  CYGWIN*) machine=Cygwin ;;
  MINGW*) machine=MinGw ;;
  MSYS_NT*) machine=Git ;;
  *) machine="UNKNOWN:${_osImplName}" ;;
  esac

  echo "${machine}"
}

function kill-by-port {
  local _port _pidList

  # Iterate over each provided port
  for _port in "$@"; do
    _pidList="$(lsof -t -i:"$_port")"

    # Replace newline characters with spaces
    _pidList=${_pidList//$'\n'/ }

    if [ -n "$_pidList" ]; then
      echo "Killing processes on port $_port: $_pidList"
      eval "kill -9 $_pidList"
    else
      echo -e "No process found running on port - $_port" >&2
    fi
  done
}

function local-ip-v4 {
  ifconfig | grep "inet 19" | awk "{ print \$2 }"
}

function local-ip-v6 {
  ifconfig | grep "inet6 f" | awk "{ print \$2 }"
}

function load-env {
  local env_file="$1"

  if [[ ! -f "$env_file" ]]; then
    echo "File not found: $env_file"
    return 1
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" == \#* ]]; then
      continue
    fi

    # Handle spaces around the equals sign
    key=$(echo "$line" | cut -d '=' -f 1 | xargs)
    value=$(echo "$line" | cut -d '=' -f 2- | xargs)

    # Remove surrounding quotes if they exist
    if [[ "$value" =~ ^\".*\"$ ]]; then
      value="${value:1:-1}"  # Remove double quotes
    elif [[ "$value" =~ ^\'.*\'$ ]]; then
      value="${value:1:-1}"  # Remove single quotes
    fi

    # Export the variable
    export "$key=$value"
  done < "$env_file"
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

  # Shift the first two arguments if they are provided
  [[ -n "$_branch" ]] && shift
  [[ -n "$_remote" ]] && shift

  # Default values if not provided
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  # Pass remaining arguments to git fetch
  git fetch "$_remote" "$_branch"
}

function git-pull {
  local _branch=$1
  local _remote=$2

  # Shift the first two arguments if they are provided
  [[ -n "$_branch" ]] && shift
  [[ -n "$_remote" ]] && shift

  # Default values if not provided
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  # Fetch the latest changes
  # shellcheck disable=SC2068
  git-fetch "$_branch" "$_remote" &&
    # Pull the changes and forward any additional arguments
    git pull "$_remote" "$_branch" --no-edit
}

function git-push {
  local _branch=$1
  local _remote=$2

  # Shift the first two arguments if they are provided
  [[ -n "$_branch" ]] && shift
  [[ -n "$_remote" ]] && shift

  # Default values if not provided
  [[ -z "$_branch" ]] && _branch="$(git-current-branch)"
  [[ -z "$_remote" ]] && _remote="origin"

  # Push the changes and forward any additional arguments
  # shellcheck disable=SC2068
  git push -u "$_remote" "$_branch" $@
}

function git-sync {
  # shellcheck disable=SC2068
  git-pull $@ &&
    git-push $@
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
