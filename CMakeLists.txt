cmake_minimum_required(VERSION 3.19...3.28)

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(FATAL_ERROR "Use out of source build
  cmake -Bbuild")
endif()

if(NOT MSVC)
get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(is_multi_config)
  message(WARNING "Please use single config generator to avoid problems")
endif()
endif()

if(NOT CMAKE_BUILD_TYPE)
  if(DEFINED ENV{CMAKE_BUILD_TYPE})
    set(CMAKE_BUILD_TYPE $ENV{CMAKE_BUILD_TYPE} CACHE STRING "default")
  else()
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Release default")
  endif()
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

project(CPython LANGUAGES C)

include(ExternalProject)
include(GNUInstallDirs)

include(options.cmake)

include(cmake/ExtProjCMake.cmake)

if(NOT WIN32)
  find_package(Autotools REQUIRED)
  include(cmake/ExtProjAutotools.cmake)
endif()

# -- main program

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/libraries.json json_meta)

# -- includes needed for Python Autotools, especially Python >= 3.11 due to https://github.com/python/cpython/pull/29483/files
string(APPEND CMAKE_C_FLAGS " -I${CMAKE_INSTALL_PREFIX}/include")

# -- libraries needed for Python Autotools

set(LDFLAGS
"$ENV{LDFLAGS} ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_FULL_LIBDIR} -Wl,-rpath,${CMAKE_INSTALL_FULL_LIBDIR}")

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

include(python.cmake)


message(STATUS "CMake ${CMAKE_VERSION} building Python ${python_version}")
message(STATUS "${python_url} => ${CMAKE_INSTALL_PREFIX}")

# --- test built binary

enable_testing()

if(WIN32)
  set(python_exe ${CMAKE_INSTALL_PREFIX}/python.exe)
else()
  set(python_exe ${CMAKE_INSTALL_PREFIX}/bin/python3)
endif()

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
