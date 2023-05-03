# Install script TODOs
# - [ ] Install fzf
# - [x] apt packages
# - [x] Install ruststuff
#   - [x] Rustup
#   - [x] ripgrep
#   - [x] fd
#   - [x] bat
#   - [x] tokei
#   - [x] license-generator
#   - [x] cargo update
#   - [ ] bottom
# - [ ] Install font
# - [ ] install newest nvim
# - [ ] link nvim dotties
# - [ ] link alacritty config
#   - [ ] install alacritty
# - [ ] link bashrc
# - [ ] link i3 config
#   - [ ] install i3
# - [ ] install lazygit
# - [ ] install nvm + node
# - [x] install docker

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
  # The basics in case I have a minimal system
  sudo apt-get install -y curl \
    git \
    build-essential \
    python3 \
    python3-pip \
    xclip
  # my preferences
  sudo apt-get install -y flameshot \
    tree \
    byobu \
    neofetch \
    htop \
    texlive-full \
    feh
}

install_docker() {
  # See: https://docs.docker.com/engine/install/ubuntu/

  # let us only do this if docker is not installed since
  # this is not idempotent by default
  if [ -x "$(command -v docker)" ]; then
    echo "Docker is already installed"
    return
  fi

  sudo apt-get update
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo groupadd docker
  sudo usermod -aG docker $USER
  newgrp docker
}

ubuntu_or_die

# Install global stuff
install_apt_packages
install_docker

# Do user space stuff
install_rust
