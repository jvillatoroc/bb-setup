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

echo "installing spice-vdagent for virtual machines"
pkg_install spice-vdagent
echo "done"

echo "installing vim curl git zsh tor tmux golang-go unzip"
pkg_install vim
pkg_install curl
pkg_install git
pkg_install zsh
pkg_install tor
pkg_install tmux
pkg_install golang-go
pkg_install go
pkg_install unzip
echo "done"

echo "change shell to zsh"
chsh -s /bin/zsh
echo "done"

case "$PKG_MGR" in
	pacman)
		# Install AUR helper - paru
		git clone https://aur.archlinux.org/paru.git
		cd paru
		makepkg -si
		echo "paru AUR helper installed successfully"
		cd $REPDIR
		PKG_MGR="paru"
		pkg_install() { sudo $PKG_MGR -S $* --noconfirm ;}
		pkg_upgrade() { sudo $PKG_MGR -Syyu ;}
		;;
esac

echo "installing python3-pip"
pkg_install python3-pip
echo "done"

echo "installing jq"
pkg_install jq
echo "done"

echo "setting up GOPATH"
echo 'GOPATH="$HOME/go"' >> ~/.profile
echo 'PATH="$PATH:$GOPATH/bin"' >> ~/.profile
source ~/.profile
echo "done"

mkdir ~/tools

echo "linking recon.sh"
cp recon.sh ~/tools/
echo "done"

echo "linking asn_domains.sh"
cp asn_domains.sh ~/tools/
echo "done"

echo "linking asn_ips.sh"
cp asn_ips.sh ~/tools/
echo "done"

echo "linking enum_domains.sh"
cp enum_domains.sh ~/tools/
echo "done"

echo "going into ~/tools/"
cd ~/tools

echo "Install SecLists"
git clone https://github.com/danielmiessler/SecLists.git
cd ~/tools
echo "done"

echo "Install commonspeak2-wordlists"
git clone https://github.com/assetnote/commonspeak2-wordlists.git
cd ~/tools
echo "done"

echo "install gobuster"
go install github.com/OJ/gobuster/v3@latest
cd ~/tools
echo "done"

echo "install dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip install -r requirements.txt
cd ~/tools
echo "done"

echo "install nmap"
pkg_install nmap
cd ~/tools
echo "done"

echo "install sqlmap"
pkg_install sqlmap
cd ~/tools
echo "done"

echo "install ffuf"
go install github.com/ffuf/ffuf@latest
cd ~/tools
echo "done"

echo "install amass"
go install github.com/OWASP/Amass/v3/...@master
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
go install github.com/tomnomnom/httprobe@latest
cd ~/tools
echo "done"

echo "install gospider"
GO111MODULE=on go install github.com/jaeles-project/gospider@latest
cd ~/tools
echo "done"

echo "install hakrawler"
go install github.com/hakluke/hakrawler@latest
cd ~/tools
echo "done"

echo "install dnsgen"
pip3 install dnsgen
cd ~/tools
echo "done"

echo "install frida"
pip3 install frida-tools
cd ~/tools
echo "done"

echo "install dnmasscan"
git clone https://github.com/rastating/dnmasscan.git
cd ~/tools
echo "done"

echo "install feroxbuster"
pkg_install feroxbuster
cd ~/tools
echo "done"

echo "install naabu"
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
cd ~/tools
echo "done"

echo "install smuggler"
git clone https://github.com/defparam/smuggler.git
cd ~/tools
echo "done"

