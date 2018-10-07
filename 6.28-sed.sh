#!/bin/bash 
INSTALL_NAME="sed-4.5"
CH_SEC=28
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
	sed -i 's/usr/tools/' build-aux/help2man &>$LOG_FILE-preconf.log
	sed -i 's/testsuite.panic-tests.sh//' Makefile.in &>>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	 ./configure --prefix=/usr \
		 --bindir=/bin &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	make html $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make check
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	install -d -m755 /usr/share/doc/sed-4.5
	install -m644 doc/sed.html /usr/share/doc/sed-4.5
	)
cleanup_6
get_build_errors_6
trailer
