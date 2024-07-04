#!/bin/sh

echo $1 $2

if [ -f $1 ]; then
    echo "File exists"
    esbmc $1 $2
else
    echo "File does not exist."
fi

