#!/bin/bash 
INSTALL_NAME="automake-1.16.1"
CH_SEC=44
CH=6

if [ ! -f ./common.sh ]; then
	echo "!! FATAL ERROR 1: './common.sh' not found"
	exit 1
fi
source common.sh
isuser root

echo ""
echo "..Building Setup Enivroment"
extract_tarball $INSTALL_NAME

time (
	echo "...Configuring $INSTALL_NAME"
	./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make -j4 check &>$LOG_FILE-check-log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log

	)
cleanup_6
get_build_errors_6
trailer
