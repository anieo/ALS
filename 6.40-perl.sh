#!/bin/bash 
INSTALL_NAME="perl-5.28.0"
CH_SEC=40
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
	echo "...PreCOnfinguring $INSTALL_NAME"
	echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
	export BUILD_ZLIB=False
	export BUILD_BZIP2=0
	echo "...Configuring $INSTALL_NAME"
	sh Configure -des -Dprefix=/usr \
		-Dvendorprefix=/usr \
		-Dman1dir=/usr/share/man/man1 \
		-Dman3dir=/usr/share/man/man3 \
		-Dpager="/usr/bin/less -isR" \
		-Duseshrplib \
		-Dusethreads &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make -k test $PROCESSOR_CORES &>$LOG_FILE-check-log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	unset BUILD_ZLIB BUILD_BZIP2
	)
cleanup_6
get_build_errors_6
trailer
