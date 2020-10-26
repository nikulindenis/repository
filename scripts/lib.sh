#!/bin/sh

libressl_version=libressl-2.5.1
libressl_archive=${libressl_version}.tar.gz

if [ -f ${libressl_archive} ]
then
	:
else
	wget -O ${libressl_archive} https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${libressl_archive}
fi

if [ -f ${libressl_archive} ]
then
	:
else
	echo wget failed.
	return -1
fi

libressl_lib=${libressl_version}/crypto/.libs/libcrypto.a
if [ -f $libressl_lib ]
then
	:
else
	tar -xzf ${libressl_archive}
	cd ${libressl_version} && ./configure && make && cd ..
fi

cc -O2 -I${libressl_version}/include peervpn.c -o peervpn ${libressl_version}/crypto/.libs/libcrypto.a && echo success!
