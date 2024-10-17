#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="debugedit-5.0.tar.xz"
DNL="https://sourceware.org/pub/debugedit/5.0/debugedit-5.0.tar.xz"
SHA256="e9ecd7d350bebae1f178ce6776ca19a648b6fe8fa22f5b3044b38d7899aa553e"

[ -d debugedit-5.0 ] && rm -rf debugedit-5.0

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

tar -Jxf ${TARBALL} && cd debugedit-5.0
./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for debugedit. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building debugedit. Sorry."
  exit 1
fi

echo
echo "running make check"
make check > debugedit.check.log 2>&1

echo "Inspect debugedit-5.0/debugedit.check.log for issues"
echo "and if looks good, as root:"
echo
echo "  cd debugedit-5.0"
echo "  make install"
echo
