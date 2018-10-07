#!/bin/bash 
INSTALL_NAME="bash-4.4.18"
CH_SEC=34
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
		--docdir=/usr/share/doc/bash-4.4.18 \
		--without-bash-malloc \
		--with-installed-readline &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTALL_NAME"
	chown-RV nobody  &>$LOG_FILE-check.log
	su nobody -s /bin/bash -c "PATH=$PATH make tests" &>>$LOG_FILE-check.log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring $INSTALL_NAME"
	mv -vf /usr/bin/bash /bin &>$LOG_FILE-postconf.log
	exec /bin/bash --login +h
	)
cleanup_6
get_build_errors_6
trailer
