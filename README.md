# CMake Python build

Build Python and its prerequisite libraries from CMake ExternalProject.

The default option `cmake -Dfind=on` searches for these libraries and builds them if not present: expat, ffi, readline, ssl,  zlib.
Because of broken system libraries and the fast build time, we always build LZMA and BZip2.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/mydir

cmake --build build
```

That makes binaries including: ~/mydir/bin/[python3,pip3]

## Why?

1. Getting Python can be tricky for license-restricted users e.g. government and corporations.
2. Building Python can be an arcane process without the automation of a high-level build system CMake.

Python uses Autotools on most platforms except Windows where Visual Studio is used.
The libraries need to be built with specific options and the forums are full of suggestions for tweaking Python build scripts etc.
This CMake project elides those issues for Linux/MacOS platforms at least.

## Compilers

Tested on Linux and MacOS with compilers including:

* Apple Clang
* Linux: GCC 4.8 and newer

The CMakeLists.txt automatically forces "clang" on MacOS and "gcc" on Linux.
This seemed to be the most robust choice, as Autotools failed to configure with choices like "gcc-*version*", Intel "icc" failed, and Intel "icx" took 100x longer than GCC to build.
