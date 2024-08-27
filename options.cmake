option(find "search for packages" on)
option(BUILD_SHARED_LIBS "build shared libraries" on)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

if(DEFINED ENV{CMAKE_BUILD_PARALLEL_LEVEL})
  set(Ncpu $ENV{CMAKE_BUILD_PARALLEL_LEVEL})
else()
  cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)
endif()

message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
file(MAKE_DIRECTORY ${CMAKE_INSTALL_PREFIX})
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.29)
  if(NOT IS_WRITABLE ${CMAKE_INSTALL_PREFIX})
    message(FATAL_ERROR "CMAKE_INSTALL_PREFIX is not writable: ${CMAKE_INSTALL_PREFIX}")
  endif()
else()
  file(TOUCH ${CMAKE_INSTALL_PREFIX}/.cmake_writable "")
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

file(READ ${CMAKE_CURRENT_LIST_DIR}/libraries.json json)

# https://www.python.org/downloads/source/
if(NOT DEFINED python_version)
  string(JSON python_version GET ${json} "python")
endif()

string(JSON bzip_version GET ${json} "bzip")

# https://github.com/libexpat/libexpat/releases
string(JSON expat_version GET ${json} "expat")

# https://github.com/libffi/libffi/releases
string(JSON ffi_version GET ${json} "ffi")

# https://github.com/tukaani-project/xz/releases
string(JSON lzma_version GET ${json} "lzma")

# https://ftp.gnu.org/gnu/readline/?C=M;O=D
string(JSON readline_version GET ${json} "readline")

# https://github.com/openssl/openssl/releases
string(JSON ssl_version GET ${json} "ssl")

# https://github.com/zlib-ng/zlib-ng/releases
string(JSON zlib_version GET ${json} "zlib")

if(AUTOCONF_VERSION VERSION_LESS 2.71)
  set(ffi_version "3.4.2")
  message(STATUS "Set FFI ${ffi_version} since Autoconf ${AUTOCONF_VERSION} < 2.71")
endif()

if(NOT python_url)
# only major.minor.release url dir
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" python_url_dir "${python_version}")
set(python_url https://www.python.org/ftp/python/${python_url_dir}/Python-${python_version}.tar.xz)
endif()

set(bzip2_url "https://gitlab.com/bzip2/bzip2/-/archive/master/bzip2-${bzip_version}.tar.bz2")

set(expat_url "https://github.com/libexpat/libexpat/archive/refs/tags/R_${expat_version}.tar.gz")

set(ffi_url "https://github.com/libffi/libffi/archive/refs/tags/v${ffi_version}.tar.gz")

set(lzma_url "https://github.com/tukaani-project/xz/archive/refs/tags/v${lzma_version}.tar.gz")

set(readline_url "https://ftp.gnu.org/gnu/readline/readline-${readline_version}.tar.gz")

set(ssl_url  "https://github.com/openssl/openssl/archive/refs/tags/openssl-${ssl_version}.tar.gz")

set(zlib_url "https://github.com/zlib-ng/zlib-ng/archive/refs/tags/${zlib_version}.tar.gz")
