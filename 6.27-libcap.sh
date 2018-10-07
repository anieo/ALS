#!/bin/bash 
INSTALL_NAME="libcap-2.25"
CH_SEC=27
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
	echo "...preonfiguring $INSTALL_NAME"
	sed -i '/install.*STALIBNAME/d' libcap/Makefile &>$LOG_FILE-preconf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make  RAISE_SETFCAP=no lib=lib prefix=/usr install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/lib/libcap.so.* /lib &>>$LOG_FILE-postconf.log
	ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so &>$LOG_FILE-postconf.log

	)
cleanup_6
get_build_errors_6
trailer
