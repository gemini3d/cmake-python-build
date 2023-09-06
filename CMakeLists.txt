cmake_minimum_required(VERSION 3.19...3.27)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "Use out of source build
  cmake -Bbuild")
endif()

# -- must override compiler to be gcc on Linux and clang on Macos.
# otherwise, Autotools is too shaky.
# Intel compiler icx/icpx works but is more than 100x slower to build.
if(APPLE)
  set(CC clang)
elseif(UNIX)
  set(CC gcc)
elseif(WIN32)
  set(CC cl)
else()
  message(FATAL_ERROR "Unsupported platform ${CMAKE_SYSTEM_NAME}")
endif()

find_program(CMAKE_C_COMPILER NAMES ${CC})
if(NOT CMAKE_C_COMPILER)
  message(WARNING "Could not hint C compiler")
  unset(CMAKE_C_COMPILER CACHE)
endif()

project(CPython
LANGUAGES C
)

include(ExternalProject)

include(options.cmake)

include(cmake/ExtProjCMake.cmake)
include(cmake/ExtProjAutotools.cmake)

# -- main program

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/libraries.json json_meta)

find_package(Autotools)

# -- includes needed for Python Autotools, especially Python >= 3.11 due to https://github.com/python/cpython/pull/29483/files
string(APPEND CMAKE_C_FLAGS " -I${CMAKE_INSTALL_PREFIX}/include")

# -- libraries needed for Python Autotools

set(LDFLAGS $ENV{LDFLAGS})
foreach(l IN ITEMS lib lib64)
  string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_PREFIX}/${l}")
  string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_PREFIX}/${l}")
endforeach()

if(APPLE)
  find_path(macinc
  NAMES stdio.h
  PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
  )
  if(macinc)
    string(APPEND CMAKE_C_FLAGS " -I${macinc}")
  endif()
  # Clang: hinting macinc breaks readline etc. with conflicting headers
  # GCC: needs the macinc hints

  find_library(macsys
  NAMES System
  NO_DEFAULT_PATH
  PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
  )
  if(macsys)
    get_filename_component(lmac ${macsys} DIRECTORY)
    string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${lmac}")
    string(APPEND LDFLAGS " -Wl,-rpath,${lmac}")
  endif()
endif()

string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${LDFLAGS}")

# --- Python itself

if(NOT python_url)
  # omit "rc*" from the url dir
  string(REGEX REPLACE "rc[0-9]+$" "" python_url_dir "${python_version}")
  set(python_url https://www.python.org/ftp/python/${python_url_dir}/Python-${python_version}.tar.xz)
endif()

if(python_url MATCHES ".git$")
  if(NOT python_tag)
    string(JSON python_tag GET ${json_meta} python tag)
  endif()
  set(python_download GIT_REPOSITORY ${python_url} GIT_TAG "${python_tag}" GIT_SHALLOW true)
else()
  set(python_download URL ${python_url})
endif()

message(STATUS "Python: ${python_url}")

include(python.cmake)


message(STATUS "CMake ${CMAKE_VERSION} building Python ${python_version} from ${python_url}")

# --- test built binary

enable_testing()

set(python_exe ${CMAKE_INSTALL_PREFIX}/bin/python3)

add_test(NAME PythonVersion COMMAND ${python_exe} --version)
set_property(TEST PythonVersion PROPERTY PASS_REGULAR_EXPRESSION "Python ${python_version}")

add_test(NAME expat
COMMAND ${python_exe} -c "import xml.parsers.expat; p = xml.parsers.expat.ParserCreate(); p.Parse('<?xml version=\"1.0\"?>')"
)

add_test(NAME lzma
COMMAND ${python_exe} -c "import lzma; t = b'Hi'; assert t == lzma.decompress(lzma.compress(t))"
)

add_test(NAME bzip2
COMMAND ${python_exe} -c "import bz2; t = b'Hi'; assert t == bz2.decompress(bz2.compress(t))"
)

add_test(NAME zlib
COMMAND ${python_exe} -c "import zlib; t = b'Hi'; assert t == zlib.decompress(zlib.compress(t))"
)

add_test(NAME ssl
COMMAND ${python_exe} -c "import ssl; assert ssl.OPENSSL_VERSION"
)

file(GENERATE OUTPUT .gitignore CONTENT "*")
