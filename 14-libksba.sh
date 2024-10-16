#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libksba-1.6.7.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.6.7.tar.bz2"
SHA256="cf72510b8ebb4eb6693eef765749d83677a03c79291a311040a5bfd79baab763"

[ -d libksba-1.6.7 ] && rm -rf libksba-1.6.7

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

tar -jxf ${TARBALL} && cd libksba-1.6.7
./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for libksba. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libksba. Sorry."
  exit 1
fi

echo "running make check"
make check > libksba.check.log 2>&1

echo "Inspect libksba-1.6.7/libksba.check.log and if all good, as root:"
echo
echo "  cd libksba-1.6.7"
echo "  make install"
echo

