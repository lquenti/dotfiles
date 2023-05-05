# Install script TODOs
# - [x] Install fzf
# - [x] apt packages
# - [x] Install ruststuff
#   - [x] Rustup
#   - [x] ripgrep
#   - [x] fd
#   - [x] bat
#   - [x] tokei
#   - [x] license-generator
#   - [x] cargo update
#   - [x] bottom
# - [ ] Install font
# - [ ] install newest nvim
# - [ ] link nvim dotties
# - [ ] link alacritty config
#   - [x] install alacritty
# - [ ] link bashrc
# - [ ] link i3 config
#   - [ ] install i3
# - [ ] install lazygit
# - [ ] install nvm + node
# - [x] install docker
# - [x] Install newest singularity
# - [ ] Anti-Root check (so that it installs the user space stuff for current user)

PATH_TO_SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH_TO_PKG_FOLDER="$HOME/pkg"

prepare_folders() {
  mkdir -p $PATH_TO_PKG_FOLDER
}

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
  cargo install bottom
  cargo install alacritty
  cargo install cargo-benchcmp
  cargo install critcmp
}

install_fzf() {
  # if ~/.fzf exists, early exit
  if [ -d "$HOME/.fzf" ]; then
    echo "fzf is already installed"
    return
  fi
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
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
    xclip \
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

install_singularity() {
  # See: https://github.com/sylabs/singularity/blob/main/INSTALL.md

  # let us only do this if singularity is not installed since
  # this is not idempotent by default
  if [ -x "$(command -v singularity)" ]; then
    echo "Singularity is already installed"
    return
  fi

  # Ensure repositories are up-to-date
  sudo apt-get update
  # Install debian packages for dependencies
  sudo apt-get install -y \
      build-essential \
      libseccomp-dev \
      libglib2.0-dev \
      pkg-config \
      squashfs-tools \
      cryptsetup \
      crun \
      uidmap \
      git \
      wget
  export VERSION=1.20.3 OS=linux ARCH=amd64  # change this as you need

  wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz \
    https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz
  sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz
  pushd $PATH_TO_PKG_FOLDER
  git clone --recurse-submodules https://github.com/sylabs/singularity.git
  cd singularity
  git checkout --recurse-submodules v3.11.2
  ./mconfig
  make -C builddir
  sudo make -C builddir install
  popd
}

ubuntu_or_die
prepare_folders

# Install global stuff
install_apt_packages
install_docker
install_singularity

# Do user space stuff
install_rust
