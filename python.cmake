if(WIN32)
  # https://pythondev.readthedocs.io/windows.html

  if(NOT MSVC)
    message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
  endif()

  ExternalProject_Add(python
  URL ${python_url}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
  INSTALL_COMMAND <SOURCE_DIR>/python.bat <SOURCE_DIR>/PC/layout --preset-default --copy "${CMAKE_INSTALL_PREFIX}"
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  ${terminal_verbose}
  )
  # https://discuss.python.org/t/windows-install-from-source-failing/25389/4
  # --precompile causes problem with script hard-coded temporary directory

  return()
endif()

# Linux prereqs: https://devguide.python.org/setup/#linux

# prereqs
foreach(l IN ITEMS bzip2 expat ffi lzma ssl zlib)
  include(${l}.cmake)
endforeach()

# Python build
set(python_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
)
if(CMAKE_BUILD_TYPE STREQUAL "Release")
  list(APPEND python_args --enable-optimizations)
endif()

set(python_cflags "${CMAKE_C_FLAGS}")
set(python_ldflags "${LDFLAGS}")

# https://docs.python.org/3/using/configure.html
if(OPENSSL_FOUND)
  cmake_path(GET OPENSSL_INCLUDE_DIR PARENT_PATH openssl_dir)
  list(APPEND python_args --with-openssl=${openssl_dir})
else()
  list(APPEND python_args --with-openssl=${CMAKE_INSTALL_PREFIX})
endif()

message(STATUS "Python configure args: ${python_args}")
message(STATUS "Python CFLAGS: ${python_cflags}")
message(STATUS "Python LDFLAGS: ${python_ldflags}")

ExternalProject_Add(python
URL ${python_url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} LDFLAGS=${python_ldflags}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "bzip2;expat;ffi;ssl;xz;zlib"
${terminal_verbose}
)
