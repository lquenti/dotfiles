# Install script TODOs
# - [ ] Install fzf
# - [ ] apt packages
#   - [ ] flameshot
# - [x] Install ruststuff
#   - [x] Rustup
#   - [x] ripgrep
#   - [x] fd
#   - [x] bat
#   - [x] tokei
#   - [x] license-generator
#   - [x] cargo update
# - [ ] Install font
# - [ ] install newest nvim
# - [ ] link nvim dotties
# - [ ] link alacritty config
# - [ ] link bashrc
# - [ ] link i3 config

PATH_TO_SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ubuntu_or_die() {
  if ! head -n 1 /etc/issue | grep -q "Ubuntu"; then
    echo "This script is only for Ubuntu systems"
    exit 1
  fi
}

install_rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  cargo install ripgrep
  cargo install fd-find
  cargo install bat
  cargo install tokei
  cargo install license-generator
  cargo install cargo-update
}

install_apt_packages() {
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install -y flameshot
}

ubuntu_or_die
install_rust
install_apt_packages
