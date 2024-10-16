#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="nettle-3.10.tar.gz"
DNL="https://ftp.gnu.org/gnu/nettle/nettle-3.10.tar.gz"
SHA256="b4c518adb174e484cb4acea54118f02380c7133771e7e9beb98a0787194ee47c"

[ -d nettle-3.10 ] && rm -rf nettle-3.10

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

tar -zxf ${TARBALL} && cd nettle-3.10
./configure --prefix=/usr --disable-static
if [ $? -ne 0 ]; then
  echo "Configure script failed for nettle. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building nettle. Sorry."
  exit 1
fi

echo "running make check"
make check > nettle.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install
chmod 755 /usr/lib/lib{hogweed,nettle}.so
install -d -m755 /usr/share/doc/nettle-3.10
install -m644 nettle.{html,pdf} /usr/share/doc/nettle-3.10
EOF

echo "Inspect nettle-3.10/nettle.check.log"
echo "If all looks good, as root:"
echo
echo "  cd nettle-3.10"
echo "  bash makeinstall.sh"
echo
