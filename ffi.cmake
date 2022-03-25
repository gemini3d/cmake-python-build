# installs CMAKE_INSTALL_PREFIX/lib64/libffi.{a,so}
include(ExternalProject)

if(find)
  find_library(libffi NAMES ffi)
endif()

if(libffi)
  add_custom_target(ffi)
  return()
endif()

string(JSON ffi_url GET ${json_meta} ffi git)
string(JSON ffi_tag GET ${json_meta} ffi tag)

set(ffi_args
--prefix=${CMAKE_INSTALL_PREFIX}
--disable-docs
CC=${CC}
)


ExternalProject_Add(ffi
GIT_REPOSITORY ${ffi_url}
GIT_TAG ${ffi_tag}
GIT_SHALLOW true
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${ffi_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)

ExternalProject_Add_Step(ffi
autogen
COMMAND <SOURCE_DIR>/autogen.sh
DEPENDEES download
DEPENDERS configure
WORKING_DIRECTORY <SOURCE_DIR>
)
# autogen.sh needs to be executed in SOURCE_DIR, not in build directory
