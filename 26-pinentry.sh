#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="pinentry-1.3.1.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.1.tar.bz2"
SHA256="bc72ee27c7239007ab1896c3c2fae53b076e2c9bd2483dc2769a16902bce8c04"

[ -d pinentry-1.3.1 ] && rm -rf pinentry-1.3.1

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

tar -jxf ${TARBALL} && cd pinentry-1.3.1
./configure --prefix=/usr \
            --enable-pinentry-tty \
            --disable-pinentry-qt5
if [ $? -ne 0 ]; then
  echo "Configure script failed for pinentry. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building pinentry. Sorry."
  exit 1
fi

echo
echo "As root:"
echo "  cd pinentry-1.3.1"
echo "  make install"
echo
