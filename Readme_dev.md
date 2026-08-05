## FFI version

We found with Python 3.15.0rc1 and
[Ubuntu 26.04](https://packages.ubuntu.com/resolute/libffi-dev)
that ctypes was missing.

```
[ERROR] _ctypes failed to import: /tmp/buildpy/python-prefix/src/python-build/build/lib.linux-aarch64-3.15/_ctypes.cpython-315-aarch64-linux-gnu.so: undefined symbol: ffi_type_void
[ERROR] _ctypes (/tmp/buildpy/python-prefix/src/python-build/build/lib.linux-aarch64-3.15/_ctypes.cpython-315-aarch64-linux-gnu.so) is missing
The necessary bits to build these optional modules were not found:
_dbm                  _gdbm                 _tkinter
To find the necessary bits, look in configure.ac and config.log.

Following modules built successfully but were removed because they could not be imported:
_ctypes
```

This is handled in ffi.cmake by checking the FFI version.nm
