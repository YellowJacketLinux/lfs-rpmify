#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libuv-v1.49.1.tar.gz"
DNL="https://dist.libuv.org/dist/v1.49.1/libuv-v1.49.1.tar.gz"
SHA256="8d84f714f4cfd167b1576a58b82430cc2166ef135463d0644964fd71c61a6766"

[ -d libuv-v1.49.1 ] && rm -rf libuv-v1.49.1

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

tar -zxf ${TARBALL} && cd libuv-v1.49.1
unset ACLOCAL
sh autogen.sh
if [ $? -ne 0 ]; then
  echo "Autogen script failed for libuv. Sorry."
  exit 1
fi
./configure --prefix=/usr --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for libuv. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libuv. Sorry."
  exit 1
fi

echo "running make check"
make check > libuv.check.log 2>&1

echo
echo "Inspect libuv-v1.49.1/libuv.check.log and if okay, as root run:"
echo
echo "  cd libuv-v1.49.1"
echo "  make install"
echo
