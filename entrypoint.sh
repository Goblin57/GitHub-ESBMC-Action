#!/bin/sh

if [[ -f $1 ]]; then
    echo "File exists"
    esbmc $1
else
    echo "File does not exist."
fi

ls
echo "---------"
cd .. && ls
echo "---------"
cd esbmc/bin && ls
echo "---------"
cd .. && ls
echo "---------"

esbmc --version