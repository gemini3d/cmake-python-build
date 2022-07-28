# installs CMAKE_INSTALL_PREFIX/lib64/libffi.{a,so}
include(ExternalProject)

if(find)
  find_library(libffi NAMES ffi)
endif()

if(libffi)
  add_custom_target(ffi)
  return()
endif()

if(NOT LIBTOOL_EXECUTABLE)
  message(FATAL_ERROR "FFI needs libtool")
endif()

string(JSON ffi_url GET ${json_meta} ffi url)
string(JSON ffi_tag GET ${json_meta} ffi tag)

set(ffi_args
--disable-docs
)


extproj_autotools(ffi ${ffi_url} ${ffi_tag} "${ffi_args}")

ExternalProject_Add_Step(ffi
autogen
COMMAND <SOURCE_DIR>/autogen.sh
DEPENDEES download
DEPENDERS configure
WORKING_DIRECTORY <SOURCE_DIR>
)
# autogen.sh needs to be executed in SOURCE_DIR, not in build directory
