#!/bin/bash

set -o errexit 
set -o nounset

# $1 operating_system argument / $2 packager_manager argument

# 1 - Install VIM if not exist on the target OS 

if [[ "$1" == "macOS" ]]; then
    echo -e "Detected MacOS system...\n"
    command -v brew >/dev/null 2>&1 || {
	echo >&2 "Not found Homebrew in your MacOs, Installing Homebrew Now"
	$SHELL -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    }

    command -v vim > /dev/null 2>&1 || {	
	brew tap homebrew/cask-versions
	brew install vim
    }
    
    brew install curl bash coreutils git fzf ripgrep bat lsd

elif [[ "$1" == 'linux' ]]; then
    echo -e "Detect Linux based system...\n"
    
    $SHELL -c "$2 curl build-essential git cmake bat fzf ripgrep"
    
    command -v vim > /dev/nul 2>&1 || {
       $SHELL -c "$2 vim"
    }

else
    echo -e "Window system is not supported for this dotfiles configuration, aborting..."
    exit 1
fi


# 2 - Copy the .vimrc into the user system

readonly VIM_DIRECTORY=$HOME/.config/vim

echo -e "Copying .vimrc file into $VIM_DIRECTORY ..."

mkdir -p "$VIM_DIRECTORY" && cp -i $PWD/vim/.vimrc $VIM_DIRECTORY/.vimrc && ln -sf $VIM_DIRECTORY/.vimrc $HOME/.vimrc && echo -e "Copied .vimrc file into your system with success!"


# Display prompt to give the user the option to select the plugin manager for vim

read -p "Do you want to install the plugins for vim? (y/n)" yn

case $yn in:
    [yY] ) chmod u+x ./vim/vim_plugins.sh && $SHELL -c "./vim/vim_plugins.sh $1 $2"
	break;
    [nN] ) echo -e "You selected to not install plugins for vim editor :("
	break;
    * ) echo "Invalid response, select between 'y,Y ' or 'n,N'"
esac


# TMUX optional installation with plugins and theme by default
