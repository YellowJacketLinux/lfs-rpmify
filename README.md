Building RPM in LFS 12.2
========================

This git is for the scripts needed to build the dependencies for the RPM Package
Manager (RPM) within a LFS 12.2 system. This is ‘Phase Three’ in `THE-PLAN.md`.

First I am attempting to build RPM 4.18.x as I successfully built that version
of RPM on LFS 11.3. However that version of RPM is EOL so once I get it building
I will not install it but instead look to see if I can the modern version of RPM
to build. I believe they changed the build system to CMake so there will almost
be some additional dependencies needed.

With dependencies through Lua built, RPM 4.18.2 builds in LFS 12.2 but there are
still three needed components for a complete RPM environment:

1. GnuPG (critical, needed to sign packages, important for package security)
2. debugedit (critical, needed for debug packages)
3. fakechroot (needed to run the test suite after building RPM)

GnuPG itself has a lot of dependencies, one of which is OpenLDAP. Hopefully I
can just build the shared libraries, those should be all that are needed.

While not a *strict* dependency, GnuTLS is a recommended dependency as is
pinentry but pinentry seems to be runtime so I probably will not build that at
least not until the RPM bootstrap is complete.

GnuTLS however will be used for *many* other things too, so I will consider it
and its dependencies as needed in this phase.

Dependency One: UnZip
---------------------

Justification: Needed to build SQLite 3 (to unpack the documentation). No build
dependencies outside of LFS.

* Script: [`01-unzip.sh`](01-unzip.sh)
* Status: Script Works

Dependency Two: SQLite3
-----------------------

Justification: Needed to build RPM itself. Depends upon UnZip for documentation.

* Script: [`02-sqlite3.sh`](02-sqlite3.sh)
* Status: Script Works

Dependency Three: libgpg-error
------------------------------

Justification: Needed to build libgcrypt, libassuan, and libksba. No build
dependencies outside of LFS.

* Script: [`03-libgpg-error.sh`](03-libgpg-error.sh)
* Status: Script Works

Dependency Four: libgcrypt
--------------------------

Justification: Needed to build RPM itself and GnuPG. Depends upon libgpg-error.

* Script: [`04-libgcrypt.sh`](04-libgcrypt.sh)
* Status: Script Works

Dependency Five: popt
---------------------

Justification: Needed to build RPM itself. No build dependencies outside of LFS.

* Script: [`05-popt.sh`](05-popt.sh)
* Status: Script Works

Dependency Six: ICU
-------------------

Justification: Needed to build libxml2. No build dependencies outside of LFS.

* Script: [`06-icu.sh`](06-icu.sh)
* Status: Script Works

Dependency Seven: libxml2
-------------------------

Justification: Needed for libarchive and CMake. Depends on ICU.

* Script: [`07-libxml2.sh`](07-libxml2.sh)
* Status: Script Works

Dependency Eight: LZO
---------------------

Justification: Needed for libarchive. No build dependencies outside of LFS.

* Script: [`08-lzo.sh`](08-lzo.sh)
* Status: Script Works

Dependency Nine: nettle
-----------------------

Justification: Needed for libarchive. No build dependencies outside of LFS.

* Script: [`09-nettle.sh`](09-nettle.sh)
* Status: Script Works

Dependency Ten: pcre2
---------------------

Justification: Needed for libarchive. No build dependencies outside of LFS.

* Script: [`10-pcre2.sh`](10-pcre2.sh)
* Status: Script Works

Dependency Eleven: libarchive
-----------------------------

Justification: Needed to build RPM and CMake. Depends upon libxml2, LZO, Nettle,
and pcre2.

* Script: [`11-libarchive.sh`](11-libarchive.sh)
* Status: Script Works

Dependency Twelve: Lua
----------------------

Justification: Needed to build RPM. No build dependencies outside of LFS.

* Script: [`12-lua.sh`](12-lua.sh)
* Status: Script Works

Dependency Thirteen: libassuan
------------------------------

Justification: Needed to build GnuPG. Requires libgpg-error.

* Script: [`13-libassuan.sh`](13-libassuan.sh)
* Status: Script Untested

Dependency Fourteen: libksba
----------------------------

Justification: Needed to build GnuPG. Requires libgpg-error.

* Script: [`14-libksba.sh`](14-libksba.sh)
* Status: Script Untested

Dependency Fifteen: npth
------------------------

Justification: Needed to build GnuPG. No dependencies outside of LFS.

* Script: [`15-npth.sh`](15-npth.sh)
* Status: Script Untested

Dependency Sixteen: libuv
-------------------------

Justification: Needed to build CMake. No dependencies outside of LFS.

* Script: [`16-libuv.sh`](16-libuv.sh)
* Status: Script Untested

Dependency Seventeen: nghttp2
-----------------------------

Justification: Needed to build CMake. Depends upon libxml2 to build.

* Script: [`17-nghttp2.sh`](17-nghttp2.sh)
* Status: Script Untested

Dependency Eighteen: CMake
--------------------------

Justification: Needed by brotli and current RPM versions. Depends upon curl,
libarchive, libuv, and nghttp2.

* Script: [`18-cmake.sh`](18-cmake.sh)
* Status: Script Untested
* Note: Rebuild once GCC Fortran available
