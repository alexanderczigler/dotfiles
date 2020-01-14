#!/bin/bash

BASHRC="$HOME/.bashrc"
PWD=`pwd`
SOURCE_LINE="source $PWD/bash/_include.bash"

grep -q -F "$SOURCE_LINE" $BASHRC || echo "$SOURCE_LINE" >> $BASHRC