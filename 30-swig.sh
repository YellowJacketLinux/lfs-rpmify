#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="swig-4.2.1.tar.gz"
DNL="https://downloads.sourceforge.net/swig/swig-4.2.1.tar.gz"
SHA256="fa045354e2d048b2cddc69579e4256245d4676894858fcf0bab2290ecf59b7d8"

[ -d swig-4.2.1 ] && rm -rf swig-4.2.1

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

tar -zxf ${TARBALL} && cd swig-4.2.1

./configure --prefix=/usr \
            --without-javascript \
            --without-maximum-compile-warnings
if [ $? -ne 0 ]; then
  echo "Configure script failed for swig. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building swig. Sorry."
  exit 1
fi

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install
cp -R Doc -T /usr/share/doc/swig-4.2.1
EOF

echo
echo "As the root user:"
echo
echo "  cd swig-4.2.1"
echo "  bash makeinstall.sh"
echo

