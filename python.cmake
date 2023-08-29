if(NOT python_url)
  # omit "rc*" from the url dir
  string(REGEX REPLACE "rc[0-9]+$" "" python_url_dir "${python_version}")
  set(python_url https://www.python.org/ftp/python/${python_url_dir}/Python-${python_version}.tar.xz)
endif()

message(STATUS "Python: ${python_url}")

if(python_url MATCHES ".git$")
  if(NOT python_tag)
    string(JSON python_tag GET ${json_meta} python tag)
  endif()
  set(download_params GIT_REPOSITORY ${python_url} GIT_TAG "${python_tag}" GIT_SHALLOW true)
else()
  set(download_params URL ${python_url})
endif()


if(WIN32)
  # https://pythondev.readthedocs.io/windows.html

  if(NOT MSVC)
    message(FATAL_ERROR "On Windows, Python is available from Microsoft Store. Python building on Windows requires Visual Studio.")
  endif()

  ExternalProject_Add(python
  ${download_params}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
  INSTALL_COMMAND ""
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 60
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
  ${download_params}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} LDFLAGS=${python_ldflags}
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 60
  DEPENDS "bzip2;expat;ffi;readline;ssl;xz;zlib"
  USES_TERMINAL_DOWNLOAD true
  USES_TERMINAL_UPDATE true
  USES_TERMINAL_PATCH true
  USES_TERMINAL_CONFIGURE true
  USES_TERMINAL_BUILD true
  USES_TERMINAL_INSTALL true
  USES_TERMINAL_TEST true
  )

endif()
