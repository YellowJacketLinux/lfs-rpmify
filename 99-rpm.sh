#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="rpm-4.20.0.tar.bz2"
DNL="https://ftp.osuosl.org/pub/rpm/releases/rpm-4.20.x/rpm-4.20.0.tar.bz2"
SHA256="56ff7638cff98b56d4a7503ff59bc79f281a6ddffcda0d238c082bedfb5fbe7b"

[ -d rpm-4.20.0 ] && rm -rf rpm-4.20.0

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi

# no git client in bootstrap phase so...
if [ ! -f rpmpgp-legacy.zip ]; then
  rm -f master.zip
  wget https://github.com/rpm-software-management/rpmpgp_legacy/archive/refs/heads/master.zip
  mv master.zip rpmpgp-legacy.zip
fi

CHECK="`sha256sum ${TARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${SHA256}" ]; then
  echo "${TARBALL} does not match expected SHA256. Sorry."
  exit 1
fi

tar -jxf ${TARBALL} && cd rpm-4.20.0
cd rpmio
cp ../../rpmpgp-legacy.zip .
unzip rpmpgp-legacy.zip
mv rpmpgp_legacy-master rpmpgp_legacy
cd ..

mkdir _build
cd _build

#cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr \
#      -DWITH_SELINUX=OFF \
#      -DWITH_SEQUOIA=OFF \
#      -DWITH_LEGACY_OPENPGP=ON \
#      -DRPM_VENDOR=gnu \
#      -DENABLE_TESTSUITE=OFF -L ..
#exit
cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr \
      -DWITH_SELINUX=OFF \
      -DWITH_SEQUOIA=OFF \
      -DWITH_LEGACY_OPENPGP=ON \
      -DRPM_VENDOR=gnu \
      -DENABLE_TESTSUITE=OFF ..
if [ $? -ne 0 ]; then
  echo "CMake configuration failed for RPM. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building RPM. Sorry."
  exit 1
fi

echo
echo "As the root user:"
echo
echo "  cd rpm-4.20.0/_build"
echo "  make install"
echo
