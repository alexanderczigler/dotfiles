#!/bin/bash

# declare all the urls
REPOS=(
  "https://aur.archlinux.org/code.git"
  "https://aur.archlinux.org/kubectl-bin.git"
  "https://aur.archlinux.org/minecraft-launcher.git"
)

# clone all the repos
for repo in "${REPOS[@]}"
do
  git clone $repo
done

# install all the packages
for D in *
do
  if [ -d "${D}" ]
  then
    echo "${D}"
    cd "${D}"
    git pull origin master
    makepkg -Acsi
    cd ..
  fi
done
