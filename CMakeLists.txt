
cmake_minimum_required(VERSION 3.20...3.23)

# -- must override compiler to be gcc on Linux and clang on Macos.
# otherwise, Autotools is too shaky.
# Intel compiler icx/icpx works but is more than 100x slower to build.
if(APPLE)
  set(CC clang)
  set(CXX clang++)
elseif(UNIX)
  set(CC gcc)
  set(CXX g++)
elseif(WIN32)
  set(CC cl)
  set(CXX cl)
else()
  message(FATAL_ERROR "Unsupported platform ${CMAKE_SYSTEM_NAME}")
endif()

find_program(CMAKE_C_COMPILER NAMES ${CC} REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES ${CXX} REQUIRED)

project(BuildPython
LANGUAGES C CXX
)

include(ExternalProject)

include(cmake/options.cmake)

# -- main program

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/libraries.json json_meta)

find_package(Autotools)

# -- includes needed for Python Autotools, especially Python >= 3.11 due to https://github.com/python/cpython/pull/29483/files
string(APPEND CMAKE_C_FLAGS " -I${CMAKE_INSTALL_PREFIX}/include")

# -- libraries needed for Python Autotools

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

if(DEFINED ENV{CONDA_PREFIX})
  message(STATUS "Conda Python detected as active. You may wish to

    conda deactivate

  to avoid conflicts with the Python build system."
  )
endif()
