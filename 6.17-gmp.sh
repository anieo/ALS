#!/bin/bash
INSTALL_NAME="gmp-6.1.2"
CH_SEC=17
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
	./configure --prefix=/usr \
		--enable-cxx \
		--disable-static \
		--docdir=/usr/share/doc/gmp-6.1.2 &>$LOG_FILE-config.log
	echo "....Making $INSTALL_NAME "
	make  $PROCESSOR_CORES &>$LOG_FILE-make.log
	make html $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "....Checking $INSTALL_NAME "
	awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log &>$LOG_FILE-check.log
	awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
	echo "....Sould pass all the 190 test case"
	read -p "Enter to confirm" -n 1 -r
	echo "....INSTALLING $INSTALL_name"	
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	make  install-html $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	)
cleanup_6
get_build_errors_6
trailer
