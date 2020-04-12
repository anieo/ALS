#!/bin/bash 
INSTALL_NAME="inetutils-1.9.4"
CH_SEC=39
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
	echo "...Configuring $INSTALL_NAME"
	./configure --prefix=/usr \
		--localstatedir=/var \
		--disable-logger \
		--disable-whois \
		--disable-rcp \
		--disable-rexec \
		--disable-rlogin \
		--disable-rsh \
		--disable-servers &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	make check $PROCESSOR_CORES &>$LOG_FILE-check-log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin &>$LOG_FILE-postconf.log
	mv -v /usr/bin/ifconfig /sbin &>>$LOG_FILE-postconf.log
	)
cleanup_6
get_build_errors_6
trailer
