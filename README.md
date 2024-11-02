Building RPM in LFS 12.2
========================

__STATUS__: Complee

This git is for the scripts needed to build the dependencies for the RPM Package
Manager (RPM) within a LFS 12.2 system. This is ‘Phase Three’ in `THE-PLAN.md`.

First I resolved the dependencies needed to build RPM 4.18.2 as I successfully
built and used RPM 4.18.1 on an LFS 11.3 system so I knew it was possible. Once
I had that building (but not installed) I resolved the dependencies needed to
build RPM 4.20.0 which is the current series.

With dependencies through Lua built, RPM 4.18.2 builds in LFS 12.2 but there are
still two needed components for a complete RPM environment:

1. GnuPG (critical, needed to sign packages, important for package security)
2. debugedit (critical, needed for debug packages)

Dependencies 13 through 27 build GnuPG.
Dependencies 28 and 29 build debugedit.

Some of the additional needed dependencies for RPM 4.20.0 (such as CMake) were
built as a result of building GnuPG, there was only one additional dependency
(audit) which itself had an unmet dependency (swig). Once those were built, I
was able to successfully build RPM 4.20.0.

RPM 4.20.0 does want to use ‘rpm-sequoia’ for digests and OpenPGP however
‘rpm-sequoia’ requires Rust and Rust is a can of worms I just do not like.
Perhaps I am wrong not to like it, but I *really* do not like it. At this
point in time I have zero plans to ever include it in YJL (add-on repositories
of course can) as I just see no value in dealing with it.

RPM 4.20.0 still supports using libgcrypt for the hashes and there is an
unsupported way to use their legacy OpenPGP parser for signatures, detailed at
[RPM PGP Legacy](https://github.com/rpm-software-management/rpmpgp_legacy)
git repository. That is implemented in my build of RPM 4.20.0.

The file [`yjl-lfs-rpm-macros`](yjl-lfs-rpm-macros) should be installed as
`/etc/rpm/macros` for LFS/YJL with RPM. The biggest issue is RPM likes to use
`/lib64` and `/usr/lib64` on `x86_64` systems but LFS (and the YJL I am
building) does not. The macro file fixes that without needing to alter RPM
itself.

RPM Test Suite
--------------

RPM 4.18.2 requires `fakechroot` to run the test suite. That project appears to
be abandoned with the last release about four years ago, and no recent activity
in the project git repository.

RPM 4.20.0 requires either `podman` or `docker` to run the test suite. As I do
not (yet) have either available, I could not run the test suite.

Dependency One: UnZip
---------------------

Justification: Needed to build SQLite 3 (to unpack the documentation). No build
dependencies outside of LFS.

* Script: [`01-unzip.sh`](01-unzip.sh)
* Status: Script Works

Dependency Two: SQLite3
-----------------------

Justification: Needed to build RPM itself and for Cyrus SASL. Depends upon UnZip
for documentation.

* Script: [`02-sqlite3.sh`](02-sqlite3.sh)
* Status: Script Works

Dependency Three: libgpg-error
------------------------------

Justification: Needed to build libgcrypt, libassuan, libksba, and pinentry. No
build dependencies outside of LFS.

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

Justification: Needed to build pinentry and GnuPG. Requires libgpg-error.

* Script: [`13-libassuan.sh`](13-libassuan.sh)
* Status: Script Works

Dependency Fourteen: libksba
----------------------------

Justification: Needed to build GnuPG. Requires libgpg-error.

* Script: [`14-libksba.sh`](14-libksba.sh)
* Status: Script Works

Dependency Fifteen: npth
------------------------

Justification: Needed to build GnuPG. No dependencies outside of LFS.

* Script: [`15-npth.sh`](15-npth.sh)
* Status: Script Works

Dependency Sixteen: libuv
-------------------------

Justification: Needed to build CMake. No dependencies outside of LFS.

* Script: [`16-libuv.sh`](16-libuv.sh)
* Status: Script Works

Dependency Seventeen: nghttp2
-----------------------------

Justification: Needed to build CMake. Depends upon libxml2 to build.

* Script: [`17-nghttp2.sh`](17-nghttp2.sh)
* Status: Script Works

Dependency Eighteen: CMake
--------------------------

Justification: Needed by brotli and current RPM versions. Depends upon curl,
libarchive, libuv, and nghttp2.

* Script: [`18-cmake.sh`](18-cmake.sh)
* Status: Script Works
* Note: Rebuild once GCC Fortran available

Dependency Nineteen: brotli
---------------------------

Justification: Neded to build GnuTLS and beneficial to future rebuild of cURL.
Requires CMake to build.

* Script: [`19-brotli.sh`](19-brotli.sh)
* Status: Script Works
* Note: Python bindings NOT built

Dependency Twenty: which
------------------------

Justification: Needed for libseccomp test suite, and by *many* test suites and
scripts on a GNU/Linux system. No build dependencies outside of LFS.

* Script: [`20-which.sh`](20-which.sh)
* Stutus: Script Works

Dependency Twenty-One: libseccomp
---------------------------------

Justification: Needed for GnuTLS. Depends upon which.

* Script: [`21-libseccomp.sh`](21-libseccomp.sh)
* Status: Script Works

Dependency Twenty-Two: GnuTLS
-----------------------------

Justification: Needed for GnuPG. Also is the preferred TLS stack for YJL. Build
requires nettle, libunistring, libtasn1, p11-kit, brotli, libidn2, libseccomp.
Runtime requires make-ca.


* Script: [`22-gnutls.sh`](22-gnutls.sh)
* Status: Script Works
* Note: Note yet built with DANE support, or Trousers support.

Dependency Twenty-Three: LMDB
-----------------------------

Justification: Needed for Cyrus SASL. No build dependencies outside of LFS.

* Script: [`23-lmdb.sh`](23-lmdb.sh)
* Status: Script Works

Dependency Twenty-Four: Cyrus SASL
----------------------------------

Justification: Needed for OpenLDAP. Requires LMDB and SQLite3

* Script: [`24-cyrus-sasl.sh`](24-cyrus-sasl.sh)
* Status: Script Works
* Note: Does not install files needed to start the auth daemon

Dependency Twenty-Five: OpenLDAP
--------------------------------

Justification: Needed for GnuPG. Requires Cyrus SASL to build.

* Script: [`25-openldap.sh`](25-openldap.sh)
* Status: Script Works
* Note: Only installs client libraries, not the daemon

Dependency Twenty-Six: pinentry
-------------------------------

Justification: Runtime dependency of GnuPG. Requires libassuan and libgpg-error.

* Script: [`26-pinentry.sh`](26-pinentry.sh)
* Status: Script Works
* Note: GUI clients not built yet

Dependency Twenty-Seven: GnuPG
------------------------------

Justification: Needed for RPM signatures. Requires libassuan, libgcrypt,
libksba, npth, OpenLDAP, GnuTLS, and pinentry.

* Script: [`27-gnupg.sh`](27-gnupg.sh)
* Status: Script Works

Dependency Twenty-Eight: elfutils
---------------------------------

Justification: LFS already installs libelf from elfutils, but debugedit needs
libdw from elfutils as well.

* Script: [`28-elfutils.sh`](28-elfutils.sh)
* Status: Script Works
* Note: Binaries in `/usr/bin` installed with an `eu-` prefix.

Dependency Twenty-Nine: debugedit
---------------------------------

Justification: Required for RPM debuginfo packages. Build requires libelf and
libdw from elfutils.

* Script: [`29-debugedit.sh`](29-debugedit.sh)
* Status: Script Works

Dependency Thirty: swig
-----------------------

Justification: Required to build audit. Build requires pcre2.

* Script: [`30-swig.sh`](30-swig.sh)
* Status: Script Works

Dependency Thirty-One: audit
----------------------------

Justification: Required to build RPM 4.20.0 (current)

* Script: [`31-audit.sh`](31-audit.sh)
* Status: Script Works
* Note: \texttt{/var/log/auditd} needs to be manually created and the configure
        switch in script needs to be updated for correct PID location, but it
        works.

Dependency Thirty-Two: cpio
---------------------------

Justification: RPM run-time dependency.

* Script: [`32-cpio.sh`](32-cpio.sh)
* Status: Script Works



Build RPM 4.20.0
----------------

* Script: [`99-rpm.sh`](99-rpm.sh)
* Status: Script Works
