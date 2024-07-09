#!/bin/sh

IFS='\n'
options=$1

directory_recursive() {
    cd $1
    for directory in $(ls -d */)
    do
        directory_recursive $directory
    done
    lsverifier $options
    cd ..
}

directory_recursive .
