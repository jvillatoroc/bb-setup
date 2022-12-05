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

REPDIR=$(pwd)

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

echo "copying tmux conf file"
ln -s $REPDIR/dotfiles-desktop/.tmux.conf
echo "done"

echo "change shell to zsh"
chsh -s /bin/zsh
echo "done"

case "$PKG_MGR" in
	pacman)
		echo "Install AUR helper - paru"
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
ln -s $REPDIR/recon.sh ~/tools/
echo "done"

echo "linking asn_domains.sh"
ln -s $REPDIR/asn_domains.sh ~/tools/
echo "done"

echo "linking asn_ips.sh"
ln -s $REPDIR/asn_ips.sh ~/tools/
echo "done"

echo "linking crawl_subdomains.sh"
ln -s $REPDIR/crawl_subdomains.sh ~/tools/
echo "done"

echo "linking spider_subdomains.sh"
ln -s $REPDIR/spider_subdomains.sh ~/tools/
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

echo "Install Jason Haddix's gist wordlists"
mkdir jhaddix
cd jhaddix
curl -LO https://gist.github.com/jhaddix/b80ea67d85c13206125806f0828f4d10/raw/c81a34fe84731430741e0463eb6076129c20c4c0/content_discovery_all.txt
curl -LO https://gist.github.com/jhaddix/f64c97d0863a78454e44c2f7119c2a6a/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
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

echo "install github-search repo"
git clone https://github.com/gwen001/github-search.git
cd ~/tools
echo "done"

echo "install Sublist3r"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
sudo pip install -r requirements.txt
cd ~/tools
echo "done"

echo "install aquatone"
case "$PKG_MGR" in
	pacman)
		pkg_install chromium
		;;
	apt)
		sudo snap install chromium
		;;
esac
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
case "$PKG_MGR" in
	pacman)
		pkg_install feroxbuster
		;;
	ubuntu)
		curl -sLO https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster_amd64.deb.zip
		unzip feroxbuster_amd64.deb.zip
		sudo apt install ./feroxbuster_*_amd64.deb
		;;
	debian)
		curl -sLO https://github.com/epi052/feroxbuster/releases/latest/download/feroxbuster_amd64.deb.zip
		unzip feroxbuster_amd64.deb.zip
		sudo apt install ./feroxbuster_*_amd64.deb
	*)
		sudo snap install feroxbuster
		ln -s ~/tools/SecLists ~/snap/feroxbuster/common/SecLists/
		;;
esac
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

echo "install favfreak"
git clone https://github.com/devanshbatham/FavFreak
cd FavFreak
virtualenv -p python3 env
source env/bin/activate
python3 -m pip install mmh3
cd ~/tools
echo "done"

echo "install knockpy"
git clone https://github.com/guelfoweb/knock.git
cd knock
pip3 install -r requirements.txt
cd ~/tools
echo "done"
