#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "Danger, Will Robinson!"
  echo "Do not execute me as r00t"
  exit 1
fi

TARBALL="lua-5.4.7.tar.gz"
DNL="https://www.lua.org/ftp/lua-5.4.7.tar.gz"
SHA256="9fbf5e28ef86c69858f6d3d34eccc32e911c1a28b4120ff3e84aaa70cfbf1e30"
PATCH="lua-5.4.7-shared_library-1.patch"
PATCHDNL="https://www.linuxfromscratch.org/patches/blfs/svn/lua-5.4.7-shared_library-1.patch"
PATCHSHA256="44324a802822f0a35d095aaad2f5f58fa7b1821ae87ae44dbcfc8a23fcd2e67e"

[ -d lua-5.4.7 ] && rm -rf lua-5.4.7

if [ ! -f ${TARBALL} ]; then
  wget ${DNL}
  if [ $? -ne 0 ]; then
    echo "Could not retrieve ${DNL}"
    echo "Sorry."
    exit 1
  fi
fi
if [ ! -f ${PATCH} ]; then
  wget ${PATCHDNL}
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
CHECK="`sha256sum ${PATCH} |awk ' { print $1 } ' `"
if [ "${CHECK}" != "${PATCHSHA256}" ]; then
  echo "${PATCH} does not match expected SHA256. Sorry."
  exit 1
fi

tar -zxf ${TARBALL} && cd lua-5.4.7

cat > lua.pc << "EOF"
V=5.4
R=5.4.7

prefix=/usr
INSTALL_BIN=${prefix}/bin
INSTALL_INC=${prefix}/include
INSTALL_LIB=${prefix}/lib
INSTALL_MAN=${prefix}/share/man/man1
INSTALL_LMOD=${prefix}/share/lua/${V}
INSTALL_CMOD=${prefix}/lib/lua/${V}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: Lua
Description: An Extensible Extension Language
Version: ${R}
Requires:
Libs: -L${libdir} -llua -lm -ldl
Cflags: -I${includedir}
EOF

patch -Np1 -i ../${PATCH}

make linux
if [ $? -ne 0 ]; then
  echo "Failed building lua. Sorry."
  exit 1
fi

echo "running make test"
make test > lua.check.log 2>&1

cat > makeinstall.sh << "EOF"
#!/bin/bash

make INSTALL_TOP=/usr                \
     INSTALL_DATA="cp -d"            \
     INSTALL_MAN=/usr/share/man/man1 \
     TO_LIB="liblua.so liblua.so.5.4 liblua.so.5.4.7" \
     install

mkdir -p /usr/share/doc/lua-5.4.7
cp doc/*.{html,css,gif,png} /usr/share/doc/lua-5.4.7
install -m644 -D lua.pc /usr/lib/pkgconfig/lua.pc
EOF

echo "Investigate lua-5.4.7/lua.check.log and if looks okay, as root:"
echo
echo " cd lua-5.4.7"
echo " bash makeinstall.sh"
echo
