#!/bin/bash

function get_type() {
    echo $(file -b $1 | tr ' ' '\n' | head -n1)
}

function gzip_get_filename() {
    echo $(gzip -l $1 | tr ' ' '\n' | tail -1)
}

function tar_get_filename() {
    echo $(tar -tf $1)
}


last_file=data
xxd -r ./data.txt > "$last_file"

while true; do
    rm -f *.gz *.tar.gz *.bz

    type=$(get_type "$last_file")
    
    if [ "$type" == "ASCII" ]; then
	echo $(cat "$last_file" | tr ' ' '\n' | tail -1)
	exit 1
    elif [ "$type" == "gzip" ]; then
	mv -f "$last_file" data.gz
	last_file=$(gzip_get_filename data.gz)
	gzip -d data.gz
    elif [ "$type" == "bzip2" ]; then 
	mv -f "$last_file" "$last_file.bz2" && bzip2 -d "$last_file.bz2"
    elif [ "$type" == "POSIX" ]; then
	mv -f "last_file" data.tar.gz
	last_file=$(tar_get_filename data.tar.gz)
	tar -xf data.tar.gz
    else
	echo "$last_file $type NOT FOUND, ABORTING..."
	exit 1
    fi
done

