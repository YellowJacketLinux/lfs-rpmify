#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libgcrypt-1.11.0.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.11.0.tar.bz2"
SHA256="09120c9867ce7f2081d6aaa1775386b98c2f2f246135761aae47d81f58685b9c"

[ -d libgcrypt-1.11.0 ] && rm -rf libgcrypt-1.11.0

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

tar -jxf ${TARBALL} && cd libgcrypt-1.11.0
./configure --prefix=/usr
if [ $? -ne 0 ]; then
  echo "Configure script failed for libgcrypt. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building libgcrypt. Sorry."
  exit 1
fi
make -C doc html
makeinfo --html --no-split -o doc/gcrypt_nochunks.html doc/gcrypt.texi
makeinfo --plaintext       -o doc/gcrypt.txt           doc/gcrypt.texi

echo "running make check"
make check > libgcrypt.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash

make install
install -d -m755 /usr/share/doc/libgcrypt-1.11.0
install -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
  /usr/share/doc/libgcrypt-1.11.0
install -d -m755 /usr/share/doc/libgcrypt-1.11.0/html
install -m644 doc/gcrypt.html/* \
  /usr/share/doc/libgcrypt-1.11.0/html
install -m644 doc/gcrypt_nochunks.html \
  /usr/share/doc/libgcrypt-1.11.0
install -m644 doc/gcrypt.{txt,texi} \
  /usr/share/doc/libgcrypt-1.11.0
EOF

echo
echo "Check the file libgcrypt-1.11.0/libgcrypt.check.log"
echo
echo "If it looks good, then as root:"
echo
echo "  cd libgcrypt-1.11.0"
echo "  bash makeinstall.sh"
echo
