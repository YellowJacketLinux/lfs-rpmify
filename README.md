Building RPM in LFS 12.2
========================

This git is for the scripts needed to build the dependencies for the RPM Package
Manager (RPM) within a LFS 12.2 system. This is ‘Phase Three’ in `THE-PLAN.md`.

First I am attempting to build RPM 4.18.x as I successfully built that version
of RPM on LFS 11.3. However that version of RPM is EOL so once I get it building
I will not install it but instead look to see if I can the modern version of RPM
to build. I believe they changed the build system to CMake so there will almost
be some additional dependencies needed.

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

Justification: Needed to build libgcrypt. No build dependencies outside of LFS.

* Script: [`03-libgpg-error.sh`](03-libgpg-error.sh)
* Status: Script Works

Dependency Four: libgcrypt
--------------------------

Justification: Needed to build RPM itself. Depends upon libgpg-error.

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

Justification: Needed for libarchive. Depends on ICU.

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

Justification: Needed to build RPM. Depends upon libxml2, LZO, Nettle, and
pcre2.

* Script: [`11-libarchive.sh`](11-libarchive.sh)
* Status: Script Works

Dependency Twelve: Lua
----------------------

Justification: Needed to build RPM. No build dependencies outside of LFS.

* Script: [`12-lua.sh`](12-lua.sh)
* Status: Script Untested
