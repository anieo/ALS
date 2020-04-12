#!/bin/bash 
INSTALL_NAME="intltool-0.51.0"
CH_SEC=42
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
	sed -i 's:\\\${:\\\$\\{:' intltool-update.in
	./configure --prefix=/usr &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make check $PROCESSOR_CORES &>$LOG_FILE-check-log
	echo "...Installing of $INSTALL_NAME"
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
	)
cleanup_6
get_build_errors_6
trailer
