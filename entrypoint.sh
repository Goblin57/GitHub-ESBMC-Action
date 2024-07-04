#!/bin/sh

echo $1
echo $2
echo $3
echo $4
echo $5

if [ -f $1 ]; then
    echo "File exists"
    esbmc $1 $2
else
    echo "File does not exist."
fi

if [ $4 = "y" ]; then
    lsverifier $5
else
    echo "LSVerifier disabled."
fi

