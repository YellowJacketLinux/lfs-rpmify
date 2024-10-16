#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="libxml2-2.13.4.tar.xz"
DNL="https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.4.tar.xz"
SHA256="65d042e1c8010243e617efb02afda20b85c2160acdbfbcb5b26b80cec6515650"

[ -d libxml2-2.13.4 ] && rm -rf libxml2-2.13.4

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

tar -Jxf ${TARBALL} && cd libxml2-2.13.4

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-static \
            --with-history \
            --with-icu \
            PYTHON=/usr/bin/python3 \
            --docdir=/usr/share/doc/libxml2-2.13.4
if [ $? -ne 0 ]; then
  echo "Configure script failed for libxml2. Sorry."
  exit 1
fi

cat > makeinstall.sh << "EOF"
#!/bin/bash

make install
rm -f /usr/lib/libxml2.la
sed '/libs=/s/xml2.*/xml2"/' -i /usr/bin/xml2-config
EOF

echo
echo "As the root user:"
echo
echo "  cd libxml2-2.13.4"
echo "  bash makeinstall.sh"
echo
