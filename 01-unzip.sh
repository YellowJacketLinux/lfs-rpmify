#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="unzip60.tar.gz"
DNL="https://downloads.sourceforge.net/infozip/unzip60.tar.gz"
SHA256="036d96991646d0449ed0aa952e4fbe21b476ce994abc276e49d30e686708bd37"
PATCH1="unzip-6.0-consolidated_fixes-1.patch"
PATCH1DNL="https://www.linuxfromscratch.org/patches/blfs/12.2/unzip-6.0-consolidated_fixes-1.patch"
PATCH1SHA256="02cfd942875ca492c8fd27dff773e633a4f0b9bb47af2c3ad2697e8df8aa79f8"
PATCH2="unzip-6.0-gcc14-1.patch"
PATCH2DNL="https://www.linuxfromscratch.org/patches/blfs/12.2/unzip-6.0-gcc14-1.patch"
PATCH2SHA256="ea5c012b75512ab1a17ab70dcd379cff2ba19c6bb4c045e5cfab45c6c5d5d924"

[ -d unzip60 ] && rm -rf unzip60

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi
if [ ! -f ${PATCH1} ]; then
  wget ${PATCH1DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${PATCH1DNL}"
    echo "Sorry."
    exit 1
  fi
fi
if [ ! -f ${PATCH2} ]; then
  wget ${PATCH2DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${PATCH2DNL}"
    echo "Sorry."
    exit 1
  fi
fi

CHECK="`sha256sum ${TARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${SHA256}" ]; then
  echo "${TARBALL} does not match expected SHA256. Sorry."
  exit 1
fi
CHECK="`sha256sum ${PATCH1} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${PATCH1SHA256}" ]; then
  echo "${PATCH1} does not match expected SHA256. Sorry."
  exit 1
fi
CHECK="`sha256sum ${PATCH2} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${PATCH2SHA256}" ]; then
  echo "${PATCH2} does not match expected SHA256. Sorry."
  exit 1
fi

tar -zxf ${TARBALL} && cd unzip60
patch -Np1 -i ../${PATCH1}
patch -Np1 -i ../${PATCH2}

make -f unix/Makefile generic

echo "As root user:"
echo
echo "  cd unzip60"
echo "  make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install"
echo
