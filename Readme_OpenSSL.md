# OpenSSL Python requirements

Python is compatible with a certain range of
[OpenSSL versions](https://github.com/openssl/openssl/blob/master/CHANGES.md).
Python 3.11 and newer
[can work with OpenSSL 3](https://github.com/python/cpython/issues/99079).

Compatible OpenSSL include:

* Python 3.13.0, OpenSSL 3.0.13 (Ubuntu 24.04 default)
* Python 3.13.0, OpenSSL 3.1.7
* Python 3.13.0, OpenSSL 3.2.3, 3.2.4

## OpenSSL versions that fail with Python

Ultimate failure of incompatible OpenSSL version may occur at Python install step:

```sh
usr/bin/install -c -m 755 Modules/_ssl.cpython-313-x86_64-linux-gnu.so /tmp/python3.13/lib/python3.13/lib-dynload/_ssl.cpython-313-x86_64-linux-gnu.so
/usr/bin/install: cannot stat 'Modules/_ssl.cpython-313-x86_64-linux-gnu.so': No such file or directory
gmake: *** [Makefile:2317: sharedinstall] Error 1
FAILED: python-prefix/src/python-stamp/python-install /tmp/build-python/python-prefix/src/python-stamp/python-install
```

OpenSSL 3.4.0, Python 3.13.0:

```
[ERROR] _hashlib failed to import: /tmp/build-python/python-prefix/src/python-build/build/lib.linux-x86_64-3.13/_hashlib.cpython-313-x86_64-linux-gnu.so: undefined symbol: EVP_MD_CTX_get_size_ex
[ERROR] _ssl failed to import: /tmp/build-python/python-prefix/src/python-build/build/lib.linux-x86_64-3.13/_ssl.cpython-313-x86_64-linux-gnu.so: undefined symbol: X509_STORE_get1_objects

The necessary bits to build these optional modules were not found:
_dbm                      _gdbm                     _tkinter
_uuid
To find the necessary bits, look in configure.ac and config.log.

Following modules built successfully but were removed because they could not be imported:
_hashlib                  _ssl

Could not build the ssl module!
Python requires a OpenSSL 1.1.1 or newer
```

OpenSSL 3.3.2, Python 3.13.0:

```
[ERROR] _ssl failed to import: /tmp/build-python/python-prefix/src/python-build/build/lib.linux-x86_64-3.13/_ssl.cpython-313-x86_64-linux-gnu.so: undefined symbol: X509_STORE_get1_objects

The necessary bits to build these optional modules were not found:
_dbm                      _gdbm                     _tkinter
_uuid
To find the necessary bits, look in configure.ac and config.log.

Following modules built successfully but were removed because they could not be imported:
_ssl

Could not build the ssl module!
Python requires a OpenSSL 1.1.1 or newer
```
