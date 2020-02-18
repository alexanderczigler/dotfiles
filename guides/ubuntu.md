git
direnv
build-essential
libssl-dev
curl
fonts-firacode
docker.io
dnsutils
guake
python-pip
virtualbox
python
oauthtool
gufw
sudo ufw enable
sudo snap install datagrip --classic
sudo snap install kubectl --classic
sudo snap install postman
sudo snap install doctl
sudo snap connect doctl:kube-config
# AWS
sudo apt install python-pip
pip install awscli --upgrade --user
# EKS
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

nvm install -s v12.8.0 --with-intl=full-icu --download=all
apt-get install -y network-manager-l2tp-gnome
sudo modprobe vboxdrv
sudo gpasswd -a alexander docker
sudo systemctl restart docker
