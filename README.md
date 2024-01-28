# CMake Python build

Build recent version of Python and its prerequisite libraries from CMake ExternalProject.
Tested with Python 3.10 ... 3.13 and newer.

Instead of
[replacing Python's Autotools scripts completely with CMake](https://github.com/python-cmake-buildsystem/python-cmake-buildsystem),
this project is a thin use of CMake ExternalProject to build Python via its own Autotools scripts.

## Build

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir

cmake --build build
```

Note: there seems to be a race condition on macOS in the "make install" Python step.
Try `cmake --build build` again if it fails; it should succeed the second time.

Optional: check that Python built-in libraries are working:

```sh
ctest --test-dir build -V
```

That makes binaries including: ~/mydir/bin/[python3,pip3].
If the system has graphical capabilities, this built Python will work with Matplotlib, etc.

### Options

`-Dfind=on`
: (default on) searches for these libraries and builds them if not present: expat, ffi, readline, ssl, zlib

`-DCMAKE_BUILD_TYPE=Release`
: build Python itself with optimization (default on). Building Python with optimization takes longer--about 2 minutes on a Mac Mini M1.
Other libraries are always set to optimize.

Optionally, select Python version *or* URL like:

`-Dpython_version="3.12.1"`
: select Python Git tag to build.

`-Dpython_url="https://www.python.org/ftp/python/3.12.1/Python-3.12.1.tar.xz"`
: URL is automatically determined from the version, but can be overridden.

## Why?

1. Getting Python can be tricky for license-restricted users e.g. government and corporations.
2. Building Python can be an arcane process without the automation of a high-level build system CMake.

Python uses Autotools except for Windows where Visual Studio is used.
The libraries need to be built with specific options and the forums are full of suggestions for tweaking Python build scripts etc.
This CMake project elides those issues.

## standalone embedded Windows script

A separate CMake script for Windows-only that downloads and extracts a standalone embedded Python is at
[scripts/install-python.cmake](./scripts/install-python.cmake).

## Compilers

Tested on Linux and MacOS with compilers including:

* Apple Clang
* Linux: GCC 4.8 and newer

The CMakeLists.txt automatically forces "clang" on MacOS and "gcc" on Linux.
This seemed to be the most robust choice, as Autotools failed to configure with choices like "gcc-*version*" and Intel "icx" took 100x longer than GCC to build.

## Prereqs

Some low level prereqs aren't built by this project:

* libtool: `dnf install libtool` or `brew install libtool-bin`
* libssl: requires Perl, `dnf install perl` or `brew install perl` for FindBin.pm
