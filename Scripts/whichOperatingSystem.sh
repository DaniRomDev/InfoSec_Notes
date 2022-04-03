#!/bin/bash

function whichOS() {
    local operating_system=''
    if [[ $OSTYPE == 'darwin'* ]]; then
       operating_system="macOS"
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ] || [ "$(uname)" == "cygwin"]; then
       operating_system="linux" 
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
       operating_system="windows"
    else 
	exit 1;
    fi

    echo "$operating_system"
}

export -f whichOS
