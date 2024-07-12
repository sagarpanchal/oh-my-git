#!/usr/bin/env zsh

zshrc="$HOME/.zshrc"

# shellcheck source=/dev/null
[ -s "$zshrc" ] && source "$zshrc"

install_syntaxHighlighting() {
  rm -rf "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
}

install_autosuggestions() {
  rm -rf "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
}

install_syntaxHighlighting
install_autosuggestions
