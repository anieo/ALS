#!/bin/bash 
INSTALL_NAME="gcc-8.2.0"
CH_SEC=21
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
	case $(uname -m) in
		x86_64)
		sed -e '/m64=/s/lib64/lib/' \
			-i.orig gcc/config/i386/t-linux64
			;;
	esac
	rm -f /usr/lib/gcc
	mkdir -v build
	cd build
	echo "...Configuring $INSTALL_NAME"
	SED=sed \ 
		../configure --prefix=/usr \
		--enable-languages=c,c++ \
		--disable-multilib \
		--disable-bootstrap \
		--disable-libmpx \
		--with-system-zlib &>$LOG_FILE-conf.log
	echo "...Making $INSTALL_NAME"
	make  $PROCESSOR_CORES &>$LOG_FILE-make.log
	echo "...Checking $INSTAL_NAME"
	ulimit -s 32768  &>$LOG_FILE-check.log
	rm ../gcc/testsuite/g++.dg/pr83239.C  &>>$LOG_FILE-check.log
	chown -Rv nobody
	su nobody -s /bin/bash -c "PATH=$PATH make -k check" &>>$LOG_FILE-check.log
	echo ../contrib/test_summary  &>$LOG_FILE-summ.log
	echo "...Installing of $INSTALL_NAME"
	make  install $PROCESSOR_CORES &>$LOG_FILE-minstall.log
	echo "...Post Configuring iand checking $INSTALL_NAME"
	ln -sv ../usr/bin/cpp /lib &>$LOG_FILE-postconf.log
	ln -sv gcc /usr/bin/cc &>>$LOG_FILE-postconf.log
	install -v -dm755 /usr/lib/bfd-plugins &>>$LOG_FILE-postconf.log
	ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
		/usr/lib/bfd-plugins/ &>>$LOG_FILE-postconf.log
	echo 'int main(){}' > dummy.c
	cc dummy.c -v -Wl,--verbose &>$LOG_FILE-dummy.log
	cc dummy.c -v -Wl,--verbose dummy.log
	readelf -l a.out | grep ': /lib' &>>$LOG_FILE-check.log
	readelf -l a.out | grep ': /lib'
	echo "....Output should be like this"
	echo "[Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
 	read -p "Enter to confirm" -n 1 -r	
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
	echo "....Output should be like this"
	echo "/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crt1.o succeeded"
	echo "/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crti.o succeeded"
	echo "/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crtn.o succeeded"
        read -p "Enter to confirm" -n 1 -r
	grep -B4 '^ /usr/include' dummy.log
	read -p "Enter to confirm" -n 1 -r 
	grep -B4 '^ /usr/include' dummy.log
	echo "....Output should be like this"
	echo "#include <...> search starts here:"
	echo "/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include"
	echo "/usr/local/include"
	echo "/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include-fixed"
	echo "/usr/include"
	read -p "Enter to confirm" -n 1 -r	
	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
	echo "....Output should be like this"
	echo "SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")"
	echo "SEARCH_DIR("/usr/local/lib64")"
	echo "SEARCH_DIR("/lib64")"
	echo "SEARCH_DIR("/usr/lib64")"
	echo "SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")"
	echo "SEARCH_DIR("/usr/local/lib")"
	echo "SEARCH_DIR("/lib")"
	echo "SEARCH_DIR("/usr/lib");"
	echo "SEARCH_DIR("/usr/i686-pc-linux-gnu/lib32")"
	echo "SEARCH_DIR("/usr/local/lib32")"
	echo "SEARCH_DIR("/lib32")"
	echo "SEARCH_DIR("/usr/lib32")"
	echo "SEARCH_DIR("/usr/i686-pc-linux-gnu/lib")"
	echo "SEARCH_DIR("/usr/local/lib")"
	echo "SEARCH_DIR("/lib")"
	echo "SEARCH_DIR("/usr/lib");"
	read -p "Enter to confirm" -n 1 -r
	grep "/lib.*/libc.so.6 " dummy.log
	grep found dummy.log
        echo "....Output should be like this"
	echo "attempt to open /lib/libc.so.6 succeeded"
	echo "found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2"
        read -p "Enter to confirm" -n 1 -r
	echo "CLEANING UPPPPP"
	rm -v dummy.c a.out dummy.log
	mkdir -pv /usr/share/gdb/auto-load/usr/lib
	mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
	)
cleanup_6
get_build_errors_6
trailer
