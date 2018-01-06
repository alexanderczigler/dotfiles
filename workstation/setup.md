# Fedora setup

Fedora setup

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

sudo yum install docker

sudo groupadd docker

sudo usermod -aG docker ilix

sudo systemctl enable docker

sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf check-update

sudo dnf install code

sudo yum install keepassx

sudo yum install nano

sudo rpm --import https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key

> /etc/yum.repos.d/insync.repo

[insync]

name=insync repo

baseurl=http://yum.insynchq.com/fedora/$releasever/

gpgcheck=1

gpgkey=https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key

enabled=1

metadata_expire=120m

sudo yum install insync

git config --global user.email "my@email.se"

git config --global user.name "meow"

