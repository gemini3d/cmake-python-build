# installs CMAKE_INSTALL_PREFIX/bin/libtool[ize]
include(ExternalProject)

if(LIBTOOL_EXECUTABLE)
  add_custom_target(libtool)
  return()
endif()

string(JSON libtool_url GET ${json_meta} libtool url)
string(JSON libtool_tag GET ${json_meta} libtool tag)

set(libtool_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CC}
)


ExternalProject_Add(libtool
GIT_REPOSITORY ${libtool_url}
GIT_TAG ${libtool_tag}
GIT_SHALLOW true
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${libtool_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
