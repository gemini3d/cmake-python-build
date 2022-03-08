# xz for python lzma module
include(ExternalProject)

if(find)
  find_package(LibLZMA)
endif()

if(LIBLZMA_FOUND)
  add_custom_target(xz)
  return()
endif()

string(JSON xz_url GET ${json_meta} xz url)
string(JSON xz_sha256 GET ${json_meta} xz sha256)

set(xz_args
--prefix=${CMAKE_INSTALL_PREFIX}
--disable-doc
CC=${CC}
)


ExternalProject_Add(xz
URL ${xz_url}
URL_HASH SHA256=${xz_sha256}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${xz_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
