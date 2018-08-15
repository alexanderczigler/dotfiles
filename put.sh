#!/bin/bash

S="~/Sourc/ilix/linux/"

# Update
cd "$S"
git pull origin master
cd -

# Setup ssh stuff
mkdir -p ~/.ssh
cp "$S".ssh/config ~/.ssh/config
cp "$S".ssh/authorized_keys ~/.ssh/authorized_keys

mkdir -p ~/.config/Code/Users
cp "$S".config/Code/Users/settings.json ~/.config/Code/Users/settings.json

# Setup bashrc
cp .bashrc ~/.bashrc
source ~/.bashrc
