option(find "search for packages" on)
option(BUILD_SHARED_LIBS "build shared libraries" on)

option(CMAKE_TLS_VERIFY "verify TLS certificates" on)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

if(DEFINED ENV{CMAKE_BUILD_PARALLEL_LEVEL})
  set(Ncpu $ENV{CMAKE_BUILD_PARALLEL_LEVEL})
else()
  cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/local" CACHE PATH "default install prefix" FORCE)
endif()

# exclude Anaconda directories from search
if(DEFINED ENV{CONDA_PREFIX})
  list(APPEND CMAKE_IGNORE_PREFIX_PATH $ENV{CONDA_PREFIX})
endif()
set(CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH false)

if(WIN32)
  return()
endif()

find_package(Autotools REQUIRED)

set(python_version "3.12.2")

# https://github.com/libexpat/libexpat/releases
set(expat_version "2_6_0")

# https://github.com/libffi/libffi/releases
set(ffi_version "3.4.6")

# https://github.com/tukaani-project/xz/releases
set(lzma_version "5.4.6")

# https://ftp.gnu.org/gnu/readline/?C=M;O=D
set(readline_version "8.2")

# https://github.com/openssl/openssl/releases
set(ssl_version "1_1_1w")

# https://github.com/zlib-ng/zlib-ng/releases
set(zlib_version "2.1.6")

if(AUTOCONF_VERSION VERSION_LESS 2.71)
  set(ffi_version "3.4.2")
  message(STATUS "Set FFI ${ffi_version} since Autoconf ${AUTOCONF_VERSION} < 2.71")
endif()

if(NOT python_url)
# only major.minor.release url dir
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" python_url_dir "${python_version}")
set(python_url https://www.python.org/ftp/python/${python_url_dir}/Python-${python_version}.tar.xz)
endif()

set(bzip2_url "https://gitlab.com/bzip2/bzip2/-/archive/master/bzip2-master.tar.bz2")

set(expat_url "https://github.com/libexpat/libexpat/archive/refs/tags/R_${expat_version}.tar.gz")

set(ffi_url "https://github.com/libffi/libffi/archive/refs/tags/v${ffi_version}.tar.gz")

set(lzma_url "https://github.com/tukaani-project/xz/archive/refs/tags/v${lzma_version}.tar.gz")

set(readline_url "https://ftp.gnu.org/gnu/readline/readline-${readline_version}.tar.gz")

set(ssl_url  "https://github.com/openssl/openssl/archive/refs/tags/OpenSSL_${ssl_version}.tar.gz")

set(zlib_url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${zlib_version}.tar.gz")
