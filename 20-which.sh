#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="which-2.21.tar.gz"
DNL="https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
SHA256="f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"

[ -d which-2.21 ] && rm -rf which-2.21

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

tar -zxf ${TARBALL} && cd which-2.21

./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for which. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building which. Sorry."
  exit 1
fi

echo "As the root user, run:"
echo
echo "  cd which-2.21"
echo "  make install"
echo
