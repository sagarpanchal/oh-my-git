#!/usr/bin/env bash

_cwd=$(dirname 0)

zshrc="$HOME/.zshrc"

install() {
  load_script=$(
    cat <<-END

# include SP if it exists [LOAD_SP]
[ -s "\$HOME/.sp/sp.sh" ] && source "\$HOME/.sp/sp.sh"
[ -s "\$HOME/.sp/sp_completion" ] && source "\$HOME/.sp/sp_completion"
END
  )

  {
    sed -i "$1" -e '/Load SP/,+3d' "$1"
    echo "$load_script" >>"$1"
  } && {
    echo "SP Installed in $1" >&1
  }
}

install "$zshrc"
