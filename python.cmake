# Linux prereqs:
# https://devguide.python.org/getting-started/setup-building/index.html#build-dependencies

# prereqs
foreach(l IN ITEMS bzip2 expat ffi lzma ssl zlib)
  include(${l}.cmake)
endforeach()

# Python build
set(python_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
CXX=${CMAKE_CXX_COMPILER}
)
if(BUILD_SHARED_LIBS)
  list(APPEND python_args --enable-shared)
endif()
if(CMAKE_BUILD_TYPE STREQUAL "Release")
  # https://docs.python.org/3/using/configure.html#cmdoption-enable-optimizations
  list(APPEND python_args --enable-optimizations)
  if(BUILD_SHARED_LIBS AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    string(APPEND CMAKE_C_FLAGS " -fno-semantic-interposition")
  endif()
endif()
if(python_jit AND python_version VERSION_GREATER_EQUAL "3.13")
  list(APPEND python_args --enable-experimental-jit)
endif()

if(BZip2_FOUND)
  # https://docs.python.org/3/using/configure.html#cmdoption-arg-BZIP2_CFLAGS
  list(APPEND python_args BZIP2_CFLAGS="-I${BZIP2_INCLUDE_DIRS}")
endif()
if(EXPAT_FOUND)
  # https://docs.python.org/3/using/configure.html#cmdoption-with-system-expat
  list(APPEND python_args --with-system-expat)
endif()
if(FFI_FOUND)
  list(APPEND python_args LIBFFI_LIBS="${CMAKE_LIBRARY_PATH_FLAG}${FFI_LIBRARY_DIR} ${CMAKE_LINK_LIBRARY_FLAG}${FFI_LIBRARY_NAME}")
endif()
if(zstd_FOUND)
  get_target_property(zstd_INCLUDE_DIRS zstd::libzstd INTERFACE_INCLUDE_DIRECTORIES)
  if(zstd_INCLUDE_DIRS)
    list(APPEND python_args LIBZSTD_CFLAGS="-I${zstd_INCLUDE_DIRS}")
  endif()
endif()


set(python_cflags "${CMAKE_C_FLAGS}")
set(python_ldflags "${LDFLAGS}")

# https://docs.python.org/3/using/configure.html
if(OPENSSL_FOUND)
  cmake_path(GET OPENSSL_INCLUDE_DIR PARENT_PATH openssl_dir)
else()
  set(openssl_dir ${CMAKE_INSTALL_PREFIX})
endif()
list(APPEND python_args --with-openssl=${openssl_dir})

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
