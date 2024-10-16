#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="popt-1.19.tar.gz"
DNL="http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.19.tar.gz"
SHA256="c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9"

[ -d popt-1.19 ] && rm -rf popt-1.19

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

tar -zxf ${TARBALL} && cd popt-1.19

./configure --prefix=/usr --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for popt. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building popt. Sorry."
  exit 1
fi

echo "running make check"
make check > popt.check.log 2>&1

echo "Inspect popt-1.19/popt.check.log"
echo "If it looks good, then as root:"
echo
echo "  cd popt-1.19"
echo "  make install"
echo
