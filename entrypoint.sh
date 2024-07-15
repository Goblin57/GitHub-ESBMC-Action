#!/bin/sh

IFS="
"
options=$1

directory_recursive() {
    cd $1
    for directory in $(ls -1 -d */)
    do
        directory_recursive $directory
    done
    lsverifier $options
    cd ..
}

directory_recursive .
