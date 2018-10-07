#!/bin/bash 
INSTALL_NAME="ncurses-6.1"
CH_SEC=24
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
	sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in &>$LOG_FILE-preconf.log
	echo "...Configuring $INSTALL_NAME"
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--with-shared \
		--without-debug \
		--without-normal \
		--enable-pc-files \
		--enable-widec&>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/lib/libncursesw.so.6* /lib &>$LOG_FILE-postconf.log
	ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so &>>$LOG_FILE-postconf.log
	for lib in ncurses form panel menu; do
		rm -vf /usr/lib/lib${lib}.so &>>$LOG_FILE-postconf.log
		echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so &>>$LOG_FILE-postconf.log 
		ln -sfv ${lib}w.pc /usr/lib/pkgconfig/${lib}.pc &>>$LOG_FILE-postconf.log
	done
	rm -vf /usr/lib/libcursesw.so
	echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
	ln -sfv libncurses.so /usr/lib/libcurses.so
	mkdir -v /usr/share/doc/ncurses-6.1
	cp -v -R doc/* /usr/share/doc/ncurses-6.1
	)
cleanup_6
get_build_errors_6
trailer
