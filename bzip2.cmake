# install bzip2, needed for Python xarray/pandas

if(find)
  find_package(BZip2)
endif()

if(BZIP2_FOUND)
  add_custom_target(bzip2)
  return()
endif()

string(JSON bzip2_url GET ${json_meta} bzip2 url)
string(JSON bzip2_sha256 GET ${json_meta} bzip2 sha256)

set(bzip2_args
libbz2.a
CC=${CMAKE_C_COMPILER}
AR=${CMAKE_AR}
RANLIB=${CMAKE_C_COMPILER_RANLIB}
LDFLAGS=${LDFLAGS}
PREFIX=${CMAKE_INSTALL_PREFIX}
)

set(bzip2_cflags "CFLAGS=-fPIC -O2 -D_FILE_OFFSET_BITS=64")

# MacOS missing stdlib.h
if(DEFINED ENV{CFLAGS})
  string(APPEND bzip2_cflags " $ENV{CFLAGS}")
endif()

find_path(sysinc
NAMES stdlib.h
PATHS /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
)
if(sysinc)
  string(APPEND bzip2_cflags " -I${sysinc}")
endif()


# build
ExternalProject_Add(bzip2
URL ${bzip2_url}
URL_HASH SHA256=${bzip2_sha256}
CONFIGURE_COMMAND ""
BUILD_COMMAND ${MAKE_EXECUTABLE} -j -C <SOURCE_DIR> ${bzip2_args} ${bzip2_cflags}
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j -C <SOURCE_DIR> install ${bzip2_args} ${bzip2_cflags}
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
