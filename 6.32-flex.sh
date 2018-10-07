#!/bin/bash 
INSTALL_NAME="flex-2.6.4"
CH_SEC=32
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
	sed -i "/math.h/a #include <malloc.h>" src/flexdef.h &>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	HELP2MAN=/tools/bin/true\
		./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Cheacking $INSTALL_NAME"
	make check $PROCESSOR_CORES &>$LOG_FILE-check.log
	echo "...Post Configuring $INSTALL_NAME"
	ln -sv flex /usr/bin/lex &>$LOG_FILE-postconf.log

	)
cleanup_6
get_build_errors_6
trailer
