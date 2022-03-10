# xz for python lzma module
# We don't find liblzma because some systems e.g. MacOS have system lzma incompatible with Python build.
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

include(ExternalProject)

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
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${xz_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
