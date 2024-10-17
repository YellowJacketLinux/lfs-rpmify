#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="openldap-2.6.8.tgz"
DNL="https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.8.tgz"
SHA256="48969323e94e3be3b03c6a132942dcba7ef8d545f2ad35401709019f696c3c4e"
PATCH="openldap-2.6.8-consolidated-1.patch"
PATCHDNL="https://www.linuxfromscratch.org/patches/blfs/12.2/openldap-2.6.8-consolidated-1.patch"
PATCHSHA256="ee96840f2235bdd810e41e8cbc2faf4d46b83c0c15be937701c147b099d0232d"

[ -d openldap-2.6.8 ] && rm -rf openldap-2.6.8

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi
if [ ! -f ${PATCH} ]; then
  wget ${PATCHDNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${PATCH}"
    echo "Sorry."
    exit 1
  fi
fi

CHECK="`sha256sum ${TARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${SHA256}" ]; then
  echo "${TARBALL} does not match expected SHA256. Sorry."
  exit 1
fi
CHECK="`sha256sum ${PATCH} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${PATCHSHA256}" ]; then
  echo "${PATCH} does not match expected SHA256. Sorry."
  exit 1
fi

tar -zxf ${TARBALL} && cd openldap-2.6.8
patch -Np1 -i ../${PATCH}
autoconf
if [ $? -ne 0 ]; then
  echo "Autoconf failed for openldap. Sorry."
  exit 1
fi

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-static \
            --enable-dynamic \
            --disable-debug \
            --disable-slapd \
            --disable-slurpd
if [ $? -ne 0 ]; then
  echo "Configure script failed for openldap. Sorry."
  exit 1
fi

make depend
if [ $? -ne 0 ]; then
  echo "make depend failed for openldap. Sorry."
  exit 1
fi
make
if [ $? -ne 0 ]; then
  echo "Failed building openldap. Sorry."
  exit 1
fi

echo
echo "As the root user:"
echo
echo "  cd openldap-2.6.8"
echo "  make install"
echo
