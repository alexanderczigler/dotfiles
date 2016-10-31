#!/bin/bash

# Settings
SOURCE="/home/ilix/Source/home"
ORIGIN=`pwd`

# Go to source location
cd $SOURCE

# Update
git pull origin master

# Setup ssh stuff
mkdir -p ~/.ssh
cp .ssh/config ~/.ssh/config

# Setup bashrc
cp .bashrc ~/.bashrc

# Go back to where you were
cd $ORIGIN