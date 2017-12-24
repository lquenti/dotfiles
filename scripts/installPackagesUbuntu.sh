# TODO: Change screenfetch for neofetch w/ 18.04
# Root Check
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt update
apt upgrade -y
# Explainations for some packages:
# libappindicator1 for rambox
# compizconfig-settings-manager  for unityconfiguration
apt install -y vim-nox libappindicator1 git zsh compizconfig-settings-manager default-jdk screenfetch keepassx texstudio texlive-full mc transmission
