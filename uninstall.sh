#!/usr/bin/env bash

_cwd=$(dirname 0)

zshrc="$HOME/.zshrc"

uninstall() {
  {
    # sed -i'.old' -e '/# SP/,+3d' "$1"
    # sed -i'.old' -e :a -e '/^\n*$/{$d;N;};/\n$/ba' "$1"
    sed -i'.old' -e :a -e '/^\n*$/{$d;N;};/\n$/ba' -e '/# SP/,+3d' "$1"
  } && {
    echo "SP Uninstalled from $1" >&1
  }
}

uninstall "$zshrc"
