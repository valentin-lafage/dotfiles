#!/bin/bash

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

create_symlink() {
  local src=$1
  local dst=${2:-$HOME}

  ln -sfv "$src" "$dst"
}

set_up_git() {
  create_symlink "$PWD/git/.gitconfig"
}

set_up_ssh() {
  local dst="$HOME/.ssh"
  mkdir -p "$dst"
  create_symlink "$PWD/ssh/config" "$dst"
  set_up_ssh_agent
}

set_up_ssh_agent() {
  local dst="$HOME/.config/1Password/ssh"
  if [[ -d "$dst" ]]; then
    create_symlink "$PWD/ssh/agent.toml" "$dst"
  fi
}

set_up_vim() {
  create_symlink "$PWD/vim/.vimrc"
  mkdir -p "$HOME/.vim"
  create_symlink "$PWD/vim/functions.vim" "$HOME/.vim"
}

set_up_tmux() {
  create_symlink "$PWD/tmux/.tmux.conf"
}

set_up_bash() {
  local dst="$HOME/.bashrc.d"
  mkdir -p "$dst"
  create_symlink "$PWD/bash/.bashrc"
  create_symlink "$PWD/bash/.bash_aliases" "$dst"
  create_symlink "$PWD/bash/functions" "$dst"
  create_symlink "$PWD/bash/.bash_variables" "$dst"
  create_symlink "$PWD/bash/.envsetup.sh"
  source "$HOME/.bashrc"
}

set_up_gnome() {
  echo -e "\n Updating GNOME"
  if command -v gnome-terminal >/dev/null 2>&1; then
    set_up_gnome_terminal
  fi
}

set_up_gnome_terminal() {
  dconf load "/org/gnome/terminal/" < "$PWD/gnome/terminal.dconf"
  if [[ $? -eq 0 ]]; then
    echo "    - $(print_bf Terminal) updated"
  fi
}

set_up_desktop_env() {
  case "$XDG_CURRENT_DESKTOP" in
    *GNOME*)
      set_up_gnome
      ;;
  esac
}

main() {
  set_up_git
  set_up_ssh
  set_up_vim
  set_up_tmux
  set_up_bash
  set_up_desktop_env
}

main
