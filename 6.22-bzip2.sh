#!/bin/bash 
INSTALL_NAME="bzip2-1.0.6"
CH_SEC=22
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
	echo "...Preconfiguring $INSTALL_NAME"
	patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch &>$LOG_FILE-preconf.log
	sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile &>>$LOG_FILE-preconf.log
	sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile &>>$LOG_FILE-preconf.log
	echo "...Making $INSTALL_NAME"
	make -f Makefile-libbz2_so $PROCESSOR_CORES &>$LOG_FILE-make.log
	make clean $PROCESSOR_CORES &>>$LOG_FILE-make.log
	make $PROCESSOR_CORES &>>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make PREFIX=/usr install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	cp -v bzip2-shared /bin/bzip2 &>$LOG_FILE-postconf.log
	cp -av libbz2.so* /lib &>>$LOG_FILE-postconf.log
	ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so &>>$LOG_FILE-postconf.log
	rm -v /usr/bin/{bunzip2,bzcat,bzip2} &>>$LOG_FILE-postconf.log
	ln -sv bzip2 /bin/bunzip2 &>>$LOG_FILE-postconf.log
	ln -sv bzip2 /bin/bzcat &>>$LOG_FILE-postconf.log
	)
cleanup_6
get_build_errors_6
trailer
