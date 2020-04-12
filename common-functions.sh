#!/bin/bash

function extract_tarball {
	if [ $CH = 5 ];then
		SRC=$LFS_MOUNT_SOURCES
	else 
		SRC=/sources
	fi
	cd /sources
	
	SRC_FILE_NAME=$(ls | egrep "^$INSTALL_NAME.+tar")
	echo ".....extracting $INSTALL_NAME tarball"
	if [ ! -d $SRC/$INSTALL_NAME/ ]; then
		tar xf $SRC_FILE_NAME
		echo "---->extracted $INSTALL_NAME"
	else
		echo "---->Tarball $FILE_NAME already extracted"
	fi
	cd /sources

	cd $(ls -d /sources/$INSTALL_NAME/)
}

function cleanup_6 {
	echo ""
	echo "... Cleaining UP $INSTALL_NAME"
	cd /sources/
	
	rm -rf $( ls -d $INSTALL_NAME )
	SRC_FILE_NAME=$(ls | egrep "^$INSTALL_NAME.+tar")
}
function self_check {
	chmod +x common.sh \
		common-functions.sh \
		common-variables.sh \
		"6.12-file.sh" \
		"6.13-readline.sh" \
		"6.14-m4.sh" \
		"6.15-bc.sh" \
		"6.16-binutils.sh" \
		"6.17-gmp.sh"

}
function isuser {
	if [ $(whoami) != $1 ];then
		echo "!! FATAL ERROR 2: MUST be run as $1"
		exit 2
	fi
}

function get_build_errors_6 {
	WARNINGS=0
	ERRORS=0
	Warnings=$(grep -in "[Ww]arnings*:* " $LOG_FILE* |wc -l)
	ERRORS=$(grep -in "[Ee]rrors*:* \|^FAIL:" $LOG_FILE* |wc -l)
	if [ $ERRORS -ne 0 ];then 
		echo "there is $ERRORS Error "
		echo "CRITICAL ERRORS ARE :"
		grep -n "[Ee]rrors*:* \|^FAIL:" $LOG_FILE* 
	else
		echo "--->NO ERRORS MAN"
	fi
}
function log_check {
	echo "...Checking logs home " 
	if [ ! -d $LFS_BUILD_LOGS_6 ]; then
		mkdir -pv $BUILD_LOGS_6
		echo "...Checking logs home done"
	fi
	

}
