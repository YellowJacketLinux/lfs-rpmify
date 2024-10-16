#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="cmake-3.30.5.tar.gz"
DNL="https://cmake.org/files/v3.30/cmake-3.30.5.tar.gz"
SHA256="9f55e1a40508f2f29b7e065fa08c29f82c402fa0402da839fffe64a25755a86d"

[ -d cmake-3.30.5 ] && rm -rf cmake-3.30.5

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

tar -zxf ${TARBALL} && cd cmake-3.30.5

sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

./bootstrap --prefix=/usr \
            --system-libs \
            --mandir=/share/man \
            --no-system-jsoncpp \
            --no-system-cppdap \
            --no-system-librhash
if [ $? -ne 0 ]; then
  echo "Bootstrap script failed for CMake. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building CMake. Sorry."
  exit 1
fi

echo "running test suite"
LC_ALL=en_US.UTF-8 bin/ctest -j4 -O cmake-3.30.5-test.log

echo
echo "Inspect cmake-3.30.5/cmake-3.30.5-test.log and if okay, as root:"
echo
echo "  cd cmake-3.30.5"
echo "  make install"
echo
