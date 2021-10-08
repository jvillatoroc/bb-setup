#!/bin/bash
OS=$(grep "^ID=" /etc/os-release | cut -d '=' -f 2)

# Setup Repos directory
REPDIR=~/git
mkdir $REPDIR
cd $REPDIR

case "$OS" in
	arch) PKG_MGR="pacman" ;;
	debian) PKG_MGR="apt" ;;
	kali) PKG_MGR="apt" ;;
	*) PKG_MGR="" && printf "Hadn't thought of this OS. Maybe open an issue or a pull request?"
esac

case "$PKG_MGR" in
	pacman)
		pkg_install() { sudo $PKG_MGR -S $* --noconfirm ;}
		pkg_upgrade() { sudo $PKG_MGR -Syyu ;}
		;;
	apt)
		pkg_install() { sudo $PKG_MGR install -y $* ;}
		pkg_upgrade() { sudo $PKG_MGR update && sudo $PKG_MGR upgrade ;}
		;;
esac

pkg_upgrade

pkg_install vim curl git zsh tor tmux golang-go unzip

# change shell to zsh
chsh -s /bin/zsh

# install Kali Linux Headless
pkg_install kali-linux-headless

pkg_install python3-pip

echo 'GOPATH="$HOME/go"' >> ~/.profile
echo 'PATH="$PATH:$GOPATH/bin"' >> ~/.profile
source ~/.profile

# install nmap
pkg_install nmap

# insstall ffuf
sudo go get -u github.com/ffuf/ffuf

mkdir ~/tools
cd ~/tools

# install Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
sudo pip install -r requirements.txt
cd ~/tools

# install aquatone
pkg_install snapd
systemctl enable --now snapd apparmor
snap install chromium
curl -O https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip
cd ~/tools

# install httprobe
go get -u github.com/tomnomnom/httprobe
