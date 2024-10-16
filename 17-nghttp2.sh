#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="nghttp2-1.63.0.tar.xz"
DNL="https://github.com/nghttp2/nghttp2/releases/download/v1.63.0/nghttp2-1.63.0.tar.xz"
SHA256="4879c75dd32a74421b9857924449460b8341796c0613ba114ab2188e4622354b"

[ -d nghttp2-1.63.0 ] && rm -rf nghttp2-1.63.0

[ -d libgcrypt-1.11.0 ] && rm -rf libgcrypt-1.11.0

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

tar -Jxf ${TARBALL} && cd nghttp2-1.63.0

./configure --prefix=/usr \
            --disable-static \
            --enable-lib-only \
            --docdir=/usr/share/doc/nghttp2-1.63.0
if [ $? -ne 0 ]; then
  echo "Configure script failed for nghttp2. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building nghttp2. Sorry."
  exit 1
fi

echo "running make check"
make check > nghttp2.check.log 2>&1

echo "Inspect nghttp2-1.63.0/nghttp2.check.log and if okay, as root:"
echo
echo "  cd nghttp2-1.63.0"
echo "  make install"
echo
