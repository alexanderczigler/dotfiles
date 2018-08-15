#!/bin/bash

S="~/Source/ilix/linux/"

cp ~/.bashrc .bashrc
cp ~/.ssh/config "$S".ssh/config
cp ~/.ssh/authorized_keys "$S".ssh/authorized_keys
cp ~/.config/Code/Users/settings.js "$S".config/Code/Users/settings.js
