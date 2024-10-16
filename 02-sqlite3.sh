#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="sqlite-autoconf-3460100.tar.gz"
DNL="https://sqlite.org/2024/sqlite-autoconf-3460100.tar.gz"
SHA256="67d3fe6d268e6eaddcae3727fce58fcc8e9c53869bdd07a0c61e38ddf2965071"
DOCTARBALL="sqlite-doc-3460100.zip"
DOCDNL="https://sqlite.org/2024/sqlite-doc-3460100.zip"
DOCSHA256="e969131f93ca79fbc64d57724a1035735881555a52600dbe69c69eab72c9fcd1"

[ -d sqlite-autoconf-3460100 ] && rm -rf sqlite-autoconf-3460100

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi
if [ ! -f ${DOCTARBALL} ]; then
  wget ${DOCDNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DOCDNL}"
    echo "Sorry."
    exit 1
  fi
fi

CHECK="`sha256sum ${TARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${SHA256}" ]; then
  echo "${TARBALL} does not match expected SHA256. Sorry."
  exit 1
fi
CHECK="`sha256sum ${DOCTARBALL} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${DOCSHA256}" ]; then
  echo "${DOCTARBALL} does not match expected SHA256. Sorry."
  exit 1
fi

tar -zxf ${TARBALL} && cd sqlite-autoconf-3460100
unzip -q ../${DOCTARBALL}

./configure --prefix=/usr \
            --disable-static \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"

make
if [ $? -ne 0 ]; then
  echo "Failed building SQLite3. Sorry."
  exit 1
fi

cat > install.sh << "EOF"
#!/bin/bash
make install
install -d -m755 /usr/share/doc/sqlite-3.46.1
cp -R sqlite-doc-3460100/* /usr/share/doc/sqlite-3.46.1
EOF

echo "As root user:"
echo
echo " cd sqlite-autoconf-3460100"
echo " bash install.sh"
echo
