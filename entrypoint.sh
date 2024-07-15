#!/bin/sh

IFS=$'\n'
set -f
options=$1

directory_recursive() {
    cd $1
    ls -1 -d */
    for directory in $(ls -1 -d */)
    do
        directory_recursive $directory
    done
    lsverifier $options
    cd ..
}

directory_recursive .
