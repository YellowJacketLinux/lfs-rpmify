#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="cpio-2.15.tar.bz2"
DNL="https://ftp.gnu.org/gnu/cpio/cpio-2.15.tar.bz2"
SHA256="937610b97c329a1ec9268553fb780037bcfff0dcffe9725ebc4fd9c1aa9075db"

[ -d cpio-2.15 ] && rm -rf cpio-2.15

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

tar -jxf ${TARBALL} && cd cpio-2.15
./configure --prefix=/usr \
            --enable-mt \
            --with-rmt=/usr/libexec/rmt
if [ $? -ne 0 ]; then
  echo "Configure script failed for cpio. Sorry."
  exit 1
fi
make
if [ $? -ne 0 ]; then
  echo "Failed building cpio. Sorry."
  exit 1
fi
makeinfo --html -o doc/html doc/cpio.texi
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi
makeinfo --plaintext -o doc/cpio.txt  doc/cpio.texi

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install
install -d -m755 /usr/share/doc/cpio-2.15/html
install -m644 doc/html/* \
              /usr/share/doc/cpio-2.15/html
install -m644 doc/cpio.{html,txt} \
              /usr/share/doc/cpio-2.15
EOF

echo
echo "As the root user:"
echo
echo "  cd cpio-2.15"
echo "  bash makeinstall.sh"
echo
