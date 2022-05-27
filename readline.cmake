# readline
include(ExternalProject)

if(find)
  find_library(libreadline NAMES readline)
endif()

if(libreadline)
  add_custom_target(readline)
  return()
endif()

string(JSON readline_url GET ${json_meta} readline url)
string(JSON readline_tag GET ${json_meta} readline tag)

set(readline_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CC}
)


ExternalProject_Add(readline
GIT_REPOSITORY ${readline_url}
GIT_TAG ${readline_tag}
GIT_SHALLOW true
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${readline_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
)
