#!/bin/sh

echo $1 $2 $3 $4

if [ -f $1 ]; then
    echo "File exists"
    esbmc $1 $2
else
    echo "File does not exist."
fi

lsverifier $3
