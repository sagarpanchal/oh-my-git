#!/usr/bin/env bash

_cwd=$(dirname 0)

zshrc="$HOME/.zshrc"

uninstall() {
  {
    sed -i "$1" -e '/Load SP/,+3d' "$1"
  } && {
    echo "SP Uninstalled from $1" >&1
  }
}

uninstall "$zshrc"
