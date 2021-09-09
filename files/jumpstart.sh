#!/usr/bin/env bash

# Get list of GUI apps from user-input and put inside the CASKS variable
CASKS=( "$@" )

#Get list of command-line apps from user-input and put inside APPS variable
APPS=()

#Housekeeping
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
NORMAL=$(tput sgr0)


# Check for Homebrew, install if not present
printf "Checking if Homebrew is installed..."

hb=$(which brew)
if [ -z "$hb" ]; then
    echo "Homebrew not installed, intiating brew installation..."
    echo "Brew installation will ask for sudo password (Your computer password)"
    echo "Our tool does not require sudo password, so it will be needed for the first time"
    echo "If you don't have Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Installation complete..."
    exit -1
else
    printf "${GREEN}Found!\n"
fi

echo "${NORMAL}Installation of GUI apps is initiating..."

if (( ${#CASKS[@]} == 0 )); then
    echo "No GUI Apps were selected to install...Skipping"
    else
    for i in "${CASKS[@]}"; do
        printf "${NORMAL}Installing $i..."
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
        #echo "Done installing $i"
    done
fi

# echo "Installation of Command-line apps is initiating..."

# if (( ${#APPS[@]} == 0 )); then
#     echo "No Command-line apps were selected to install...Skipping"
#     else
#     for i in "${APPS[@]}"; do
#         echo "Installing $i"
#         brew install "$i"
#         echo "Done installing $i"
#     done
# fi


printf "\n${NORMAL}Status: ${GREEN}%s ${NORMAL}ew apps installed, ${YELLOW}%s ${NORMAL}app was already installed\n" "$s" "$a"
