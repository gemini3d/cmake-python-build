string(JSON python_url GET ${json_meta} python url)
string(JSON python_sha256 GET ${json_meta} python sha256)

if(WIN32)
  # https://pythondev.readthedocs.io/windows.html

  if(NOT (CMAKE_C_COMPILER_ID STREQUAL MSVC AND CMAKE_CXX_COMPILER_ID STREQUAL MSVC))
    message(FATAL_ERROR "On Windows, Python is available from Microsoft Store. Python building on Windows requires Visual Studio.")
  endif()

  ExternalProject_Add(python
  URL ${python_url}
  URL_HASH SHA256=${python_sha256}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
  INSTALL_COMMAND ""
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 15
  )

else()
  # Linux prereqs: https://devguide.python.org/setup/#linux

  if(NOT Autotools_FOUND)
    message(FATAL_ERROR "Python on Unix-like systems needs Autotools")
  endif()

  # prereqs
  foreach(l bzip2 expat ffi lzma readline ssl zlib)
    include(${l}.cmake)
  endforeach()

  # Python build
  set(python_args
  --prefix=${CMAKE_INSTALL_PREFIX}
  CC=${CC}
  CXX=${CXX}
  )

  set(python_cflags "${CMAKE_C_FLAGS}")
  set(python_ldflags "${LDFLAGS}")

  if(OPENSSL_FOUND)
    cmake_path(GET OPENSSL_INCLUDE_DIR PARENT_PATH openssl_dir)
    list(APPEND python_args --with-openssl=${openssl_dir})
  else()
    list(APPEND python_args --with-openssl=${CMAKE_INSTALL_PREFIX})
  endif()

  ExternalProject_Add(python
  URL ${python_url}
  URL_HASH SHA256=${python_sha256}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} LDFLAGS=${python_ldflags}
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 15
  DEPENDS "bzip2;expat;ffi;readline;ssl;xz;zlib"
  )

endif()
