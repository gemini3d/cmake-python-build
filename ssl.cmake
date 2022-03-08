# installs OpenSSL CMAKE_INSTALL_PREFIX/lib64/lib{crypto,ssl}.{a,so}
include(ExternalProject)

if(find)
  find_package(OpenSSL)
endif()

if(OpenSSL_FOUND)
  add_custom_target(ssl)
  return()
endif()

string(JSON ssl_url GET ${json_meta} ssl git)
string(JSON ssl_tag GET ${json_meta} ssl tag)

set(ssl_args
--prefix=${CMAKE_INSTALL_PREFIX}
--openssldir=${CMAKE_INSTALL_PREFIX}
CC=${CC}
)
# bad options?
# --no-ssl2
# --no-weak-ssl-ciphers

ExternalProject_Add(ssl
GIT_REPOSITORY ${ssl_url}
GIT_TAG ${ssl_tag}
GIT_SHALLOW true
CONFIGURE_COMMAND <SOURCE_DIR>/config ${ssl_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install_sw
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
