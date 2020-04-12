#!/bin/bash 
INSTALL_NAME="readline-7.0"
CH_SEC=13
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
	sed -i '/MV.*old/d' Makefile.in &>$LOG_FILE-preconf.log
	sed -i '/{OLDSUFF}/c:' support/shlib-install &>>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	./configure \
		--prefix=/usr \
		--disable-static \
		--docdir=/usr/share/doc/readline-7.0 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make SHLIB_LIBS="-L/tools/lib -lncursesw" $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make SHLIB_LIBS="-L/tools/lib -lncurses" install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/lib/lib{readline,history}.so.* /lib &>$LOG_FILE-postconf.log
	chmod -v u+w /lib/lib{readline,history}.so.* &>$LOG_FILE-postconf.log
	ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so &>$LOG_FILE-postconf.log
	ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so &>$LOG_FILE-postconf.log
	install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0 &>$LOG_FILE-postconf.log

	)
cleanup_6
get_build_errors_6
trailer
