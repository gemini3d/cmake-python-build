# readline

if(find)
  find_library(libreadline NAMES readline)
endif()

if(libreadline)
  add_custom_target(readline)
  return()
endif()

string(JSON readline_url GET ${json_meta} readline url)
string(JSON readline_sha256 GET ${json_meta} readline sha256)

set(readline_args
--prefix=${CMAKE_INSTALL_PREFIX}
)


ExternalProject_Add(readline
URL ${readline_url}
URL_HASH SHA256=${readline_sha256}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${readline_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
