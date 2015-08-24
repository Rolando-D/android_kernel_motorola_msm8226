#!/bin/bash

# Writen by Caio Oliveira aka Caio99BR <caiooliveirafarias0@gmail.com>
# Edited by RolanDroid

# How to Use:
# For first you need to install curl "sudo apt-get install curl"
# ./patch link.to.commit

# This script can apply three commits at once.
# . patch link.to.first.commit link.to.second.commit link.to.third.commit

# Colorize and add text parameters
grn=$(tput setaf 2)             #  Green
txtbld=$(tput bold)             # Bold
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
txtrst=$(tput sgr0)        

echo "${bldblu}this is an open source script, feel free to use and share it...${txtrst}"


echo "${bldgrn}Cleaned rebase-apply!${txtrst}"

rm -rf .git/rebase-apply 

# First patch
curl $1.patch | git am

# Second Patch
if ! [ "$2" == "" ]; then
curl $2.patch | git am
fi

# Third Patch
if ! [ "$3" == "" ]; then
curl $3.patch | git am
fi

