#!/bin/bash

BASHRC="$HOME/.bashrc"
PWD=`pwd`
SOURCE_LINE="source $PWD/bash/_include.bash"

if [ ! -z $BASHRC ]; then
    echo " - [x] No bashrc found, creating empty file at $BASHRC"
    touch $BASHRC
fi;

grep -q -F "$SOURCE_LINE" $BASHRC || echo "$SOURCE_LINE" >> $BASHRC