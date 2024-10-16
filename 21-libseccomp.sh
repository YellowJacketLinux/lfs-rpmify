#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libseccomp-2.5.5.tar.gz"
DNL="https://github.com/seccomp/libseccomp/releases/download/v2.5.5/libseccomp-2.5.5.tar.gz"
SHA256="248a2c8a4d9b9858aa6baf52712c34afefcf9c9e94b76dce02c1c9aa25fb3375"

[ -d libseccomp-2.5.5 ] && rm -rf libseccomp-2.5.5

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

tar -zxf ${TARBALL} && cd libseccomp-2.5.5

./configure --prefix=/usr --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for libseccomp. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libseccomp. Sorry."
  exit 1
fi

echo "running make check"
make check > libseccomp.check.log 2>&1

echo
echo "Inspect libseccomp-2.5.5/libseccomp.check.log"
echo "and if it looks good, as root run:"
echo
echo "  cd libseccomp-2.5.5"
echo "  make install"
echo

