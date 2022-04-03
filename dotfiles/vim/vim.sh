#!/bin/bash
source "../../Scripts/whichOperatingSystem.sh"
source "../../Scripts/whichPackageManager.sh"

set -o errexit 
set -o nounset

# 1 - Install VIM if not exist on the target OS 
operating_system=$(whichOS)

if [[ "$operating_system" == "macOS" ]]; then
    echo -e "Detected MacOS system...\n"
    command -v brew >/dev/null 2>&1 || {
	echo >&2 "Not found Homebrew in your MacOs, Installing Homebrew Now"
	$SHELL -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    }

    command -v vim > /dev/null 2>&1 || {	
	brew tap homebrew/cask-versions
	brew install vim coreutils
    }

elif [[ "$operating_system" == 'linux' ]]; then
    echo -e "Detect Linux based system...\n"
    package_manager=$(whichPM)
    
    command -v vim > /dev/nul 2>&1 || {
       $SHELL -c "$package_manager build-essential vim"
    } 
else
    echo -e "Window system is not supported for this dotfiles configuration, aborting..."
    exit 1
fi


# 2 - Copy the .vimrc into the user system

readonly VIM_DIRECTORY=$HOME/.config/vim

echo -e "Copying .vimrc file into $VIM_DIRECTORY ..."

mkdir -p "$VIM_DIRECTORY" && cp -i $PWD/.vimrc $VIM_DIRECTORY/.vimrc && ln -sf $VIM_DIRECTORY/.vimrc $HOME/.vimrc && echo -e "Copied basic .vimrc file with success!"


