#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libarchive-3.7.7.tar.xz"
DNL="https://github.com/libarchive/libarchive/releases/download/v3.7.7/libarchive-3.7.7.tar.xz"
SHA256="879acd83c3399c7caaee73fe5f7418e06087ab2aaf40af3e99b9e29beb29faee"

[ -d libarchive-3.7.7 ] && rm -rf libarchive-3.7.7

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

tar -Jxf ${TARBALL} && cd libarchive-3.7.7
./configure --prefix=/usr --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for libarchive. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libarchive. Sorry."
  exit 1
fi

echo "running make check"
LC_ALL=C.UTF-8 make check > libarchive.check.log 2>&1

echo "Investigate libarchive-3.7.7/libarchive.check.log"
echo "and if it looks okay, as root:"
echo
echo "  cd libarchive-3.7.7"
echo "  make install"
echo
