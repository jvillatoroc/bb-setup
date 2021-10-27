#!/bin/bash
OS=$(grep "^ID=" /etc/os-release | cut -d '=' -f 2)

case "$OS" in
	arch) PKG_MGR="pacman" ;;
	debian) PKG_MGR="apt" ;;
	kali) PKG_MGR="apt" ;;
	ubuntu) PKG_MGR="apt" ;;
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

echo "installing vim curl git zsh tor tmux golang-go unzip"
pkg_install vim curl git zsh tor tmux golang-go unzip
echo "done"

echo "change shell to zsh"
chsh -s /bin/zsh
echo "done"

# echo "install Kali Linux Headless"
#pkg_install kali-linux-headless
#echo "done"

echo "installing python3-pip"
pkg_install python3-pip
echo "done"

echo "setting up GOPATH"
echo 'GOPATH="$HOME/go"' >> ~/.profile
echo 'PATH="$PATH:$GOPATH/bin"' >> ~/.profile
source ~/.profile
echo "done"

mkdir ~/tools
cd ~/tools

echo "Install SecLists"
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools
echo "done"

echo "install nmap"
pkg_install nmap
echo "done"

echo "install ffuf"
sudo go get -u github.com/ffuf/ffuf
echo "done"

echo "install amass"
#sudo go get -u github.com/OWASP/Amass.git
curl -LO https://github.com/OWASP/Amass/releases/download/v3.14.2/amass_linux_amd64.zip
unzip amass_linux_amd64.zip
cd ~/tools
echo "done"

echo "install Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
sudo pip install -r requirements.txt
cd ~/tools
echo "done"

echo "install aquatone"
pkg_install chromium
curl -LO https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip
cd ~/tools
echo "done"

echo "install httprobe"
go get -u github.com/tomnomnom/httprobe
echo "done"
