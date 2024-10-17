#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="LMDB_0.9.31.tar.gz"
DNL="https://github.com/LMDB/lmdb/archive/LMDB_0.9.31.tar.gz"
SHA256="dd70a8c67807b3b8532b3e987b0a4e998962ecc28643e1af5ec77696b081c9b0"

[ -d lmdb-LMDB_0.9.31 ] && rm -rf lmdb-LMDB_0.9.31

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

tar -zxf ${TARBALL} && cd lmdb-LMDB_0.9.31

cd libraries/liblmdb
make
if [ $? -ne 0 ]; then
  echo "Failed building LMDB. Sorry."
  exit 1
fi
sed -i 's| liblmdb.a||' Makefile

echo
echo "As the root user:"
echo
echo "  cd lmdb-LMDB_0.9.31/libraries/liblmdb"
echo "  make prefix=/usr install"
