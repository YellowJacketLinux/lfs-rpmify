#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="brotli-1.1.0.tar.gz"
DNL="https://github.com/google/brotli/archive/v1.1.0/brotli-1.1.0.tar.gz"
SHA256="e720a6ca29428b803f4ad165371771f5398faba397edf6778837a18599ea13ff"

[ -d brotli-1.1.0 ] && rm -rf brotli-1.1.0

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

tar -zxf ${TARBALL} && cd brotli-1.1.0

mkdir build && cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      ..
make
if [ $? -ne 0 ]; then
  echo "Failed building brotli. Sorry."
  exit 1
fi

echo "running make test"
make test > brotli.test.log 2>&1

echo
echo "Inspect brotli-1.1.0/build/brotli.test.log and if looks reasonable,"
echo "as root run:"
echo
echo "  cd brotli-1.1.0/build"
echo "  make install"
