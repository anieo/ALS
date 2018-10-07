#!/bin/bash 
INSTALL_NAME="attr-2.4.48"
CH_SEC=25
CH=6

if [ ! -f ./common.sh ]; then
	echo "!! FATAL ERROR 1: './common.sh' not found"
	exit 1
fi
source common.sh
isuser root
check_log
echo ""
echo "..Building Setup Enivroment"
extract_tarball $INSTALL_NAME

time (
	echo "...Configuring $INSTALL_NAME"
	 ./configure --prefix=/usr \
		 --bindir=/bin \
		 --disable-static \
		 --sysconfdir=/etc \
		 --docdir=/usr/share/doc/attr-2.4.48 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make check$PROCESSOR_CORES &>$LOG_FILE-check.log
	echo "...Installing of $INSTALL_NAME"
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/lib/libattr.so.* /lib
	ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
	)
cleanup_6
get_build_errors_6
trailer
