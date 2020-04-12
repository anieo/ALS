#!/bin/bash
INSTALL_NAME="file-5.34"
CH_SEC=12
CH=6

if [ ! -f ./common.sh ]; then
	echo "!! FATAL ERROR 1: './common.sh' not found"
	exit 1
fi
source common.sh
isuser root
echo ""
echo ".. Building Setup Enviroment"
extract_tarball $INSTALL_NAME

time(

	echo "....configuring $INSTALL_NAME"
	./configure --prefix=/usr  &>$LOG_FILE-config.log
	echo "....Making $INSTALL_NAME "
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "....Checking $INSTALL_NAME "
	make check $PROCESSOR_CORES &>$LOG_FILE-check.log
	echo "....INSTALLING $INSTALLNAM "
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	)
cleanup_6
get_build_errors_6
trailer
