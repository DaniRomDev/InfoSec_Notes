#!/bin/bash

# Give the option to choose the plugin manager for vim editor

# https://github.com/junegunn/vim-plug
function vimplug_install() {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Update the .vimrc basic file with the plugin configuration
    cp .vimrc ./plugins_conf/.vimrc.tmp && cat ./plugins_conf/.vimrc_plug >> .vimrc.tmp | awk '!x[$0]++' .vimrc_temp \
	mv -f ./plugins_conf/.vimrc.temp $HOME/.config/vim/.vimrc

}

# https://github.com/VundleVim/Vundle.vim
function vundle_install() {
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
}

read -p "Choose the plugin manager you want to use: [vp]vimplug, [v]undle " plugin_manager

case $plugin_manager in:
    [vp] ) vimplug_install() 
	break;
    [v] ) vundle_install()
	break;
esac


