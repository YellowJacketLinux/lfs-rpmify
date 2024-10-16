#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="pcre2-10.44.tar.bz2"
DNL="https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.bz2"
SHA256="d34f02e113cf7193a1ebf2770d3ac527088d485d4e047ed10e5d217c6ef5de96"

[ -d pcre2-10.44 ] && rm -rf pcre2-10.44

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

tar -jxf ${TARBALL} && cd pcre2-10.44

./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.44 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for pcre2. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building pcre2. Sorry."
  exit 1
fi

echo "running make check"
make check > pcre2.check.log 2>&1
echo

echo "Inspect pcre2-10.44/pcre2.check.log and if looks okay, as root:"
echo
echo "  cd pcre2-10.44"
echo "  make install"
echo

