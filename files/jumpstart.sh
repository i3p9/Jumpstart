#!/usr/bin/env bash

#Start timer
(( start=SECONDS ))

# Get list of GUI apps from user-input and put inside the CASKS variable
CASKS=( "$@" )

#Get list of command-line apps from user-input and put inside APPS variable
APPS=()

#Housekeeping (Defining colors)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)

cat << "EEF"

   _                           _             _
  (_)_   _ _ __ ___  _ __  ___| |_ __ _ _ __| |_
  | | | | | '_ ` _ \| '_ \/ __| __/ _` | '__| __|
  | | |_| | | | | | | |_) \__ \ || (_| | |  | |_
 _/ |\__,_|_| |_| |_| .__/|___/\__\__,_|_|   \__|
|__/                |_|

EEF

printf "Checking if Homebrew is installed..."
# Checking if Homebrew is installed or not
hb=$(which brew)
if [ -z "$hb" ]; then
    printf "${RED}Not Installed\n"
    printf "\n${LIME_YELLOW}NOTICE: Brew installation will ask for sudo password (Your computer password)\n"
    printf "This tool does not require sudo password, so it will be needed just once only for installing homebrew\n\n"
    while true; do
        read -p "${NORMAL}Do you wish to install Homebrew? (Yes/No): " yn
        case $yn in
            [Yy]* ) /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; break;;
            [Nn]* ) printf "${RED}Installation Aborted. Please run it again if you want to proceed.\nExiting...\n"; exit;;
            * ) printf "${NORMAL}Please answer either yes or no. ";;
        esac
    done
    printf "${GREEN}Homebrew installation successful...\n"
else
    printf "${GREEN}Installed!\n"
fi

echo "${NORMAL}Installation of GUI apps is initiating..."

s=0
a=0

if (( ${#CASKS[@]} == 0 )); then
    printf "No GUI Apps were selected to install...${YELLOW}Skipping"
    else
    for i in "${CASKS[@]}"; do
        printf "${NORMAL}Installing ${POWDER_BLUE}$i${NORMAL}..."
        res=$(( brew install --cask "$i" ) 2>&1)

        if echo -q "$res" | grep -q 'was successfully installed';then
            s=$(( s+1 ))
            printf "${GREEN}Done!\n"
        elif echo "$res" | grep -q 'is already installed';then
            a=$(( a+1 ))
            printf "${YELLOW}Skipped! (Already Installed)\n"
        elif echo "$res" | grep -q 'No Cask with this name exists';then
            n=$(( n+1 ))
            printf "${RED}Not Found!\n"
        fi
    done
fi

(( end=SECONDS ))
(( duration=end-start ))

printf "\n${NORMAL}⚡Run successful. Took %s seconds to complete.\n${GREEN}%s ${NORMAL}new apps installed, ${YELLOW}%s ${NORMAL}app was skipped (already installed)\n" "$duration" "$s" "$a"

printf "\nPlease feel free to contribute or report bugs. https://github.com/i3p9/Jumpstarter\n"
