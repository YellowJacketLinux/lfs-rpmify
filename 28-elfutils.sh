#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="elfutils-0.191.tar.bz2"
DNL="https://sourceware.org/ftp/elfutils/0.191/elfutils-0.191.tar.bz2"
SHA256="df76db71366d1d708365fc7a6c60ca48398f14367eb2b8954efc8897147ad871"

[ -d elfutils-0.191 ] && rm -rf elfutils-0.191

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

tar -jxf ${TARBALL} && cd elfutils-0.191

./configure --prefix=/usr \
            --disable-rpath \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy \
            --program-prefix="eu-"
if [ $? -ne 0 ]; then
  echo "Configure script failed for elfutils. Sorry."
  exit 1
fi

make
if [ $? -ne 0 ]; then
  echo "Failed building elfutils. Sorry."
  exit 1
fi

echo "running make check"
make check > elfutils.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash
make install
rm -f /usr/lib/libasm.a
rm -f /usr/lib/libdw.a
rm -f /usr/lib/libelf.a
EOF

echo
echo "Inspect elfutils-0.191/elfutils.check.log for issues."
echo "If okay, as root run:"
echo
echo "  cd elfutils-0.191"
echo "  bash makeinstall.sh"
echo
