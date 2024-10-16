#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="lzo-2.10.tar.gz"
DNL="https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
SHA256="c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"

[ -d lzo-2.10 ] && rm -rf lzo-2.10

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

tar -zxf ${TARBALL} && cd lzo-2.10

./configure --prefix=/usr \
            --enable-shared \
            --disable-static \
            --docdir=/usr/share/doc/lzo-2.10
if [ $? -ne 0 ]; then
  echo "Configure script failed for LZO. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building LZO. Sorry."
  exit 1
fi

echo "running make check"
make check > lzo.check.log 2>&1

echo
echo "Inspect lzo-2.10/lzo.check.log"
echo "If it looks good, as root:"
echo
echo "  cd lzo-2.10"
echo "  make install"
echo
