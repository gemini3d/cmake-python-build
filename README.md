# CMake Python build

Build Python and its prerequisite libraries from CMake ExternalProject.

The default option `cmake -Dfind=on` searches for these libraries and builds them if not present: bzip2, expat, ffi, ssl, xz, zlib.

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
This CMake project elides those issues for Linux platforms at least.
In the near future we intend this project to work with MacOS as well.
