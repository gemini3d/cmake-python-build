
if(WIN32)
  # https://pythondev.readthedocs.io/windows.html

  if(NOT MSVC)
    message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
  endif()

  ExternalProject_Add(python
  ${python_download}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
  INSTALL_COMMAND ""
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 60
  ${terminal_verbose}
  )

else()
  # Linux prereqs: https://devguide.python.org/setup/#linux

  if(NOT Autotools_FOUND)
    message(FATAL_ERROR "Python on Unix-like systems needs Autotools")
  endif()

  # prereqs
  foreach(l IN ITEMS bzip2 expat ffi lzma readline ssl zlib)
    include(${l}.cmake)
  endforeach()

  # Python build
  set(python_args
  --prefix=${CMAKE_INSTALL_PREFIX}
  CC=${CC}
  --with-system-expat
  )
  if(CMAKE_BUILD_TYPE STREQUAL "Release")
    list(APPEND python_args --enable-optimizations)
  endif()

  set(python_cflags "${CMAKE_C_FLAGS}")
  set(python_ldflags "${LDFLAGS}")

  if(OPENSSL_FOUND)
    get_filename_component(openssl_dir ${OPENSSL_INCLUDE_DIR} DIRECTORY)
    list(APPEND python_args --with-openssl=${openssl_dir})
  else()
    list(APPEND python_args --with-openssl=${CMAKE_INSTALL_PREFIX})
  endif()

  ExternalProject_Add(python
  ${python_download}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} LDFLAGS=${python_ldflags}
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 60
  DEPENDS "bzip2;expat;ffi;readline;ssl;xz;zlib"
  ${terminal_verbose}
  )

endif()
