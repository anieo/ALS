#!/bin/bash 
INSTALL_NAME="pkg-config-0.29.2"
CH_SEC=23
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
	./configure --prefix=/usr \
		--with-internal-glib \
		--disable-host-tool \
		--docdir=/usr/share/doc/pkg-config-0.29.2 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make check $PROCESSOR_CORES &>$LOG_FILE-check.log
	echo "...Installing of $INSTALL_NAME"
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	)
cleanup_6
get_build_errors_6
trailer
