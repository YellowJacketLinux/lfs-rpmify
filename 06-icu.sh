#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="icu4c-75_1-src.tgz"
DNL="https://github.com/unicode-org/icu/releases/download/release-75-1/icu4c-75_1-src.tgz"
SHA256="cb968df3e4d2e87e8b11c49a5d01c787bd13b9545280fc6642f826527618caef"

[ -d icu ] && rm -rf icu

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

tar -zxf ${TARBALL} && cd icu

cd source

./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for icu. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building icu. Sorry."
  exit 1
fi

echo "Running check"
make check > icu.check.log 2>&1

echo "Inspect icu/source/icu.check.log"
echo
echo "If it looks okay, then as root:"
echo
echo "  cd icu/source"
echo "  make install"
echo
