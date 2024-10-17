#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="cyrus-sasl-2.1.28.tar.gz"
DNL="https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
SHA256="7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"

[ -d cyrus-sasl-2.1.28 ] && rm -rf cyrus-sasl-2.1.28

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

tar -zxf ${TARBALL} && cd cyrus-sasl-2.1.28

sed '/saslint/a #include <time.h>'       -i lib/saslutil.c
sed '/plugin_common/a #include <time.h>' -i plugins/cram.c

./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --enable-auth-sasldb                \
            --with-dblib=lmdb                   \
            --with-dbpath=/var/lib/sasl/sasldb2 \
            --with-sphinx-build=no              \
            --with-saslauthd=/var/run/saslauthd
if [ $? -ne 0 ]; then
  echo "Configure script failed for Cyrus SASL. Sorry."
  exit 1
fi

make -j1
if [ $? -ne 0 ]; then
  echo "Failed building Cyrus SASL. Sorry."
  exit 1
fi

cat > makeinstall.sh << "EOF"
#!/bin/bash

make install
install -d -m700 /var/lib/sasl
install -d -m755 /usr/share/doc/cyrus-sasl-2.1.28/html
install -m644 saslauthd/LDAP_SASLAUTHD /usr/share/doc/cyrus-sasl-2.1.28
install -m644 doc/legacy/*.html /usr/share/doc/cyrus-sasl-2.1.28/html
EOF

echo
echo "As the root user:"
echo
echo "  cd cyrus-sasl-2.1.28"
echo "  bash makeinstall.sh"
echo
