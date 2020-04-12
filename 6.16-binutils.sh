#!/bin/bash
INSTALL_NAME="binutils-2.31.1"
CH_SEC=16
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
	echo "...Preconfiguring $INSTALL_NAME"
	if [ $(expect -c "spawn ls") != "spawn ls" ];then
		echo "...PTY is not Working"
	else
		echo "...Congrats PTY is working fine"
	fi
	mkdir -v build &>$LOG_FILE-preconf.log
	cd build
	pwd &>$LOG_FILE-preconf.log
	echo "....configuring $INSTALL_NAME"
	../configure --prefix=/usr \
		--enable-gold \
		--enable-ld=default \
		--enable-plugins \
		--enable-shared \
		--disable-werror \
		--enable-64-bit-bfd \
		--with-system-zlib &>$LOG_FILE-config.log
	echo "....Making $INSTALL_NAME "
	make tooldir=/usr $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "....Checking $INSTALL_NAME "
	make -k check $PROCESSOR_CORES &>$LOG_FILE-check.log
	echo "....INSTALLING $INSTALL_NAME "
	make tooldir=/usr install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	)
cleanup_6
get_build_errors_6
trailer
