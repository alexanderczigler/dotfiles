#!/bin/bash

# Update
git pull origin master

# Setup ssh stuff
mkdir -p ~/.ssh
cp .ssh/config ~/.ssh/config

# Setup bashrc
cp .bashrc ~/.bashrc
source ~/.bashrc
