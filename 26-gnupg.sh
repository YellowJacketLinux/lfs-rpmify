#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="gnupg-2.4.5.tar.bz2"
DNL="https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.5.tar.bz2"
SHA256="f68f7d75d06cb1635c336d34d844af97436c3f64ea14bcb7c869782f96f44277"

[ -d gnupg-2.4.5 ] && rm -rf gnupg-2.4.5

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

tar -jxf ${TARBALL} && cd gnupg-2.4.5
mkdir build && cd build
../configure --prefix=/usr \
             --localstatedir=/var \
             --sysconfdir=/etc \
             --docdir=/usr/share/doc/gnupg-2.4.5
if [ $? -ne 0 ]; then
  echo "Configure script failed for GnuPG. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building GnuPG. Sorry."
  exit 1
fi

makeinfo --html --no-split -I doc -o doc/gnupg_nochunks.html ../doc/gnupg.texi
makeinfo --plaintext       -I doc -o doc/gnupg.txt           ../doc/gnupg.texi
make -C doc html

echo "running make check"
make check > gnupg.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install
install -d -m755 /usr/share/doc/gnupg-2.4.5/html
install -m644 doc/gnupg_nochunks.html \
              /usr/share/doc/gnupg-2.4.5/html/gnupg.html
install -m644 ../doc/*.texi doc/gnupg.txt \
              /usr/share/doc/gnupg-2.4.5
install -m644 doc/gnupg.html/* \
              /usr/share/doc/gnupg-2.4.5/html
EOF

echo
echo "Inspect gnupg-2.4.5/build/gnupg.check.log"
echo "If all looks good, then as root:"
echo
echo "  cd gnupg-2.4.5/build"
echo "  bash makeinstall.sh"
echo
