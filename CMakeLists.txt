
cmake_minimum_required(VERSION 3.20...3.23)

project(BuildPython
LANGUAGES C CXX
VERSION 1.0.0
)

include(ExternalProject)

include(cmake/options.cmake)

# -- main program

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/libraries.json json_meta)

find_package(Autotools)

# -- libraries, especially needed for Python Autotools

set(LDFLAGS $ENV{LDFLAGS})
foreach(l lib lib64)
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
    cmake_path(GET macsys PARENT_PATH lmac)
    string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${lmac}")
    string(APPEND LDFLAGS " -Wl,-rpath,${lmac}")
  endif()
endif()

string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${LDFLAGS}")

include(python.cmake)
