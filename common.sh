#!/bin/bash

echo "###################################"
echo "###	$INSTALL_NAME		###"
echo "###	Chapter $CH.$CH_SEC		###"
echo "###################################"


echo " "
echo "Loading common functions...."

if [ ! -f ./common-functions.sh ]; then
	echo "!! FATAL ERROR 1: './common-functions.sh' not found"
	exit 1
fi
source common-functions.sh
self_check
echo ""
echo "Loading common variables...."

if [ ! -f ./common-variables.sh ]; then
	echo "!! FATAL ERROR 1: './common-variables.sh' not found"
	exit 1
fi
source common-variables.sh

function trailer {
	echo "1###########################################"
	echo "1####### END OF CHAPTER $CH.$CH_SEC ########"
	echo "1###########################################"
	cd /sources/ALFS/
}

log_check

