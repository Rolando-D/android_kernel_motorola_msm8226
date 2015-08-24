#!/bin/bash

# Written by RolanDroid 

# how to use?
# ./CHANGELOG.sh 

grn=$(tput setaf 2)             #  Green
txtbld=$(tput bold)             # Bold
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
txtrst=$(tput sgr0)

echo "${bldgrn}this is an open source script, feel free to use and share it${txtbld}"

echo "${bldblu}Info of MonsterKernel...${txtbld}"

echo "${bldgrn}Version=${txtbld}"V1

echo "${bldblu}Changelog of MonsterKernel...${txtbld}"\


git log --oneline    
