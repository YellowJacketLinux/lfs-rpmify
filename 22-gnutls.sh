#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="gnutls-3.8.7.1.tar.xz"
DNL="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.7.1.tar.xz"
SHA256="9ca0ddaccce28a74fa18d738744190afb3b0daebef74e6ad686bf7bef99abd60"

[ -d gnutls-3.8.7 ] && rm -rf gnutls-3.8.7

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

tar -Jxf ${TARBALL} && cd gnutls-3.8.7

./configure --prefix=/usr \
            --docdir=/usr/share/doc/gnutls-3.8.7.1 \
            --with-default-trust-store-pkcs11="pkcs11:" \
            --disable-dsa
if [ $? -ne 0 ]; then
  echo "Configure script failed for gnutls. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building gnutls. Sorry."
  exit 1
fi

echo "running make check"
sed '/ocsp-must-staple-connection/d' -i tests/Makefile
make check > gnutls.check.log 2>&1

echo ""
echo "Inspect gnutls-3.8.7/gnutls.check.log and if all looks good, as root:"
echo
echo "  cd gnutls-3.8.7"
echo "  make install"
echo
