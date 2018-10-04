#!/bin/bash

echo "Extracting $1"
tar -xvf $1*
cd "$1"
echo "Moving into $1 directory"


