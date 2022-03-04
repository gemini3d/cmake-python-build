
cmake_minimum_required(VERSION 3.20...3.23)

project(BuildPython
LANGUAGES C CXX
VERSION 1.0.0
)

include(ExternalProject)

include(options.cmake)

# -- main program

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/libraries.json json_meta)

find_program(MAKE_EXECUTABLE
NAMES gmake make
DOC "GNU Make (or compatible)"
)

set(LDFLAGS $ENV{LDFLAGS})
foreach(l lib lib64)
  string(APPEND LDFLAGS " ${CMAKE_LIBRARY_PATH_FLAG}${CMAKE_INSTALL_PREFIX}/${l}")
  string(APPEND LDFLAGS " -Wl,-rpath,${CMAKE_INSTALL_PREFIX}/${l}")
endforeach()
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS}")
string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT " ${LDFLAGS}")

include(python.cmake)
