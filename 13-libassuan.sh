#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libassuan-3.0.1.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-3.0.1.tar.bz2"
SHA256="c8f0f42e6103dea4b1a6a483cb556654e97302c7465308f58363778f95f194b1"

[ -d libassuan-3.0.1 ] && rm -rf libassuan-3.0.1

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

tar -jxf ${TARBALL} && cd libassuan-3.0.1

./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for libassuan. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libgcrypt. Sorry."
  exit 1
fi
make -C doc html
makeinfo --html --no-split -o doc/assuan_nochunks.html doc/assuan.texi
makeinfo --plaintext       -o doc/assuan.txt           doc/assuan.texi

echo "running make check"
make check > libassuan.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install

install -d -m755 /usr/share/doc/libassuan-3.0.1/html
install -m644 doc/assuan.html/* \
  /usr/share/doc/libassuan-3.0.1/html
install -m644 doc/assuan_nochunks.html \
  /usr/share/doc/libassuan-3.0.1
install -m644 doc/assuan.{txt,texi}
  /usr/share/doc/libassuan-3.0.1
EOF

echo
echo "Inspect libassuan-3.0.1/libassuan.check.log and if all good, as root:"
echo
echo "  cd libassuan-3.0.1"
echo "  bash makeinstall.sh"
echo
