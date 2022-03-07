# installs CMAKE_INSTALL_PREFIX/lib64/libffi.{a,so}

if(find)
  find_library(libffi NAMES ffi)
endif()

if(libffi)
  add_custom_target(ffi)
  return()
endif()

if(NOT MAKE_EXECUTABLE)
  message(FATAL_ERROR "FFI requires GNU Make.")
endif()

string(JSON ffi_url GET ${json_meta} ffi url)
string(JSON ffi_sha256 GET ${json_meta} ffi sha256)

set(ffi_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
CXX=${CMAKE_CXX_COMPILER}
--disable-docs
)


ExternalProject_Add(ffi
URL ${ffi_url}
URL_HASH SHA256=${ffi_sha256}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${ffi_args}
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
