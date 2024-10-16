#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libgpg-error-1.50.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.50.tar.bz2"
SHA256="69405349e0a633e444a28c5b35ce8f14484684518a508dc48a089992fe93e20a"

[ -d libgpg-error-1.50 ] && rm -rf libgpg-error-1.50

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

tar -jxf ${TARBALL} && cd libgpg-error-1.50
./configure --prefix=/usr

make
if [ $? -ne 0 ]; then
  echo "Failed building libgpg-error. Sorry."
  exit 1
fi
echo "As root user:"
echo
echo "  cd libgpg-error-1.50"
echo "  make install"
echo
