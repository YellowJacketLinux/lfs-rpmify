#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="audit-4.0.2.tar.gz"
DNL="https://people.redhat.com/sgrubb/audit/audit-4.0.2.tar.gz"
SHA256="d5d1b5d50ee4a2d0d17875bc6ae6bd6a7d5b34d9557ea847a39faec531faaa0a"

[ -d audit-4.0.2 ] && rm -rf audit-4.0.2

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

tar -zxf ${TARBALL} && cd audit-4.0.2
./configure --prefix=/usr \
	    --sysconfdir=/etc \
	    --sharedstatedir=/var/lib \
	    --docdir=/usr/share/doc/audit-4.0.2
if [ $? -ne 0 ]; then
  echo "Configure script failed for audit. Sorry."
  exit 1
fi
make
if [ $? -ne 0 ]; then
  echo "Failed building audit. Sorry."
  exit 1
fi
echo
echo "Running make check"
make check > audit.check.log
echo

echo "Inspect audit-4.0.2/audit.check.log and if okay, as root:"
echo
echo "  cd audit-4.0.2"
echo "  make install"
echo
