#!/bin/bash 
INSTALL_NAME="acl-2.2.53"
CH_SEC=26
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
	#echo "...preonfiguring $INSTALL_NAME"
	#&>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	 ./configure --prefix=/usr \
		 --bindir=/bin \
		 --disable-static \
		 --libexecdir=/usr/lib \
		 --docdir=/usr/share/doc/acl-2.2.53 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/lib/libacl.so.* /lib &>$LOG_FILE-postconf.log
	ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so &>>$LOG_FILE-postconf.log

	)
cleanup_6
get_build_errors_6
trailer
