#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="npth-1.7.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/npth/npth-1.7.tar.bz2"
SHA256="8589f56937b75ce33b28d312fccbf302b3b71ec3f3945fde6aaa74027914ad05"

[ -d npth-1.7 ] && rm -rf npth-1.7

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

tar -jxf ${TARBALL} && cd npth-1.7
./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for npth. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building npth. Sorry."
  exit 1
fi

echo "running make check"
make check > npth.check.log 2>&1

echo
echo "Inspect npth-1.7/npth.check.log and if all good, as root:"
echo
echo "  cd npth-1.7"
echo "  make install"
echo
