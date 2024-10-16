Building RPM in LFS 12.2
========================

This git is for the scripts needed to build the dependencies for the RPM Package
Manager (RPM) within a LFS 12.2 system. This is ‘Phase Three’ in `THE-PLAN.md`.

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
* Status: Script Untested

Dependency Three: libgpg-error
------------------------------

Justification: Needed to build libgcrypt. No build dependencies outside of LFS.

* Script: [`03-libgpg-error.sh`](03-libgpg-error.sh)
* Status: Script Untested


