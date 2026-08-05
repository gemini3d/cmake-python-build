# installs ${CMAKE_INSTALL_PREFIX}/lib/libffi.{a,so}

if(find_ffi)
  find_package(FFI)

  if(FFI_FOUND)
    if(FFI_VERSION VERSION_GREATER_EQUAL "3.7.0" OR python_version VERSION_LESS "3.15.0")
      cmake_path(GET FFI_LIBRARIES PARENT_PATH FFI_LIBRARY_DIR)
      cmake_path(GET FFI_LIBRARIES FILENAME FFI_LIBRARY_NAME)
      add_custom_target(ffi)
      return()
    endif()
  endif()
endif()

set(FFI_FOUND false)
message(STATUS "Building FFI ${ffi_version} from ${ffi_url} to be compatible with Python ${python_version}")

if(NOT LIBTOOL_EXECUTABLE)
  message(FATAL_ERROR "building FFI needs libtool executable. Package name:
Debian-like: libtool-bin
RHEL-like: libtool")
endif()

set(ffi_args --disable-docs)

extproj_autotools(ffi ${ffi_url} "${ffi_args}")

ExternalProject_Add_Step(ffi
autogen
COMMAND <SOURCE_DIR>/autogen.sh
DEPENDEES download
DEPENDERS configure
WORKING_DIRECTORY <SOURCE_DIR>
)
# autogen.sh needs to be executed in SOURCE_DIR, not in build directory
