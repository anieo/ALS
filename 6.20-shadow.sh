#!/bin/bash 
INSTALL_NAME="shadow-4.6"
CH_SEC=20
CH=6

if [ ! -f ./common.sh ]; then
	echo "!! FATAL ERROR 1: './common.sh' not found"
	exit 1
fi
source common.sh
isuser root
check_log
echo ""
echo "..Building Setup Enivroment"
extract_tarball $INSTALL_NAME

time (
	echo "...preconfiguring $INSTALL_NAME";
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
	find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
	find man -name Makefile.in -exec sed -i 's/passwd\.5 / /' {} \;
	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
			-e 's@/var/spool/mail@/var/mail@' etc/login.defs;
	sed -i 's/1000/999/' etc/useradd;
	echo "...Configuring $INSTALL_NAME"
	./configure --sysconfdir=/etc --with-group-name-max-length=32 &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Installing of $INSTALL_NAME"
	make install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	mv -v /usr/bin/passwd /bin
	echo "...configureing Shadow";
	pwconv
	grpconv
	echo "...Changing root password"
	passwd root
	)
cleanup_6
get_build_errors_6
trailer
