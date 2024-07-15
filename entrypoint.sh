#!/bin/sh

options=$1

directory_recursive() {
    cd $1
    for directory in ./*/
    do
        directory_recursive $directory
    done
    lsverifier $options
    cd ..
}

directory_recursive .
