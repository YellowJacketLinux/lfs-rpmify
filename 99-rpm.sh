#!/bin/bash

### First using RPM 4.19.x and then I'll try latest

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="rpm-4.18.2.tar.bz2"
DNL="https://ftp.osuosl.org/pub/rpm/releases/rpm-4.18.x/rpm-4.18.2.tar.bz2"
SHA256="ba7eee1bc2c6f83be73c0a40d159c625cbaed976b3ac044233404fb25ae1b979"

[ -d rpm-4.18.2 ] && rm -rf rpm-4.18.2

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi

CHECK="`sha256sum ${TARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${SHA256}" ]; then
  echo "${TARBALL} does not match expected SHA256. Sorry."
  exit 1
fi

tar -jxf ${TARBALL} && cd rpm-4.18.2

./configure \
  --prefix=/usr \
  --libdir=/usr/lib \
  --enable-zstd=yes        \
  --enable-libelf=yes      \
  --enable-ndb             \
  --enable-sqlite=yes      \
  --disable-rpath          \
  --enable-python          \
  --with-crypto=libgcrypt  \
  --disable-inhibit-plugin \
  --with-cap               \
  --with-acl > ../RPM-CONFIGURE.TXT 2>&1

echo "Inspect RPM-CONFIGURE.TXT for dependency issues."
