#!/bin/bash
INSTALL_NAME=bc-1.07.1
CH_SEC=15
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
	echo "...Preonfiguring $INSTALL_NAME"
	cat fix-libmath_h > bc/fix-libmath_h
	
	ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6 &>$LOG_FILE-preconf.log
	ln -sfv libncurses.so.6 /usr/lib/libncurses.so &>$LOG_FILE-preconf.log
	sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure &>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	./configure --prefix=/usr \
		--with-readline \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info &>$LOG_FILE-config.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing $INSTALL_NAME"
	echo "quit" | ./bc/bc -l Test/checklib.b &>$LOG_FILE-check.log 
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	)

cleanup_6
get_build_errors_6
trailer