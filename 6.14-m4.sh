#!/bin/bash
INSTALL_NAME="m4-1.4.18"
CH_SEC=14
CH=6

if [ ! -f ./common.sh ]; then
	echo "!! FATAL ERROR 1: './common.sh' not found"
	exit 1
fi
source common.sh
isuser root
echo ""
echo "..Building Setup Enviroment"
extract_tarball $INSTALL_NAME

time(
	echo "...Preconfiguring $INSTALL_NAME"
	sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c &>$LOG_FILE-preconf.log
	echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h &>>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	./configure --prefix=/usr &>$LOG_FILE-config
	echo "...Making $INSTALL_NAME"
	make $PROCESS_CORES &>$LOG_FILE-make
	echo "...CHECKING $INSTALL_NAME"
	make check $PROCESS_CORES &>$LOG_FILE-check
	echo "...INSTALLING $INSTALL_NAME"
	make install $PROCESS_CORES &>$LOG_FILE-minstall
)
cleanup_6
get_build_errors_6
trailer

