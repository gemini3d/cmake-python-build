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

  set(python_args
  --prefix=${CMAKE_INSTALL_PREFIX}
  CC=${CMAKE_C_COMPILER}
  CXX=${CMAKE_CXX_COMPILER}
  )

  if(NOT MAKE_EXECUTABLE)
    message(FATAL_ERROR "Python requires GNU Make.")
  endif()

  include(bzip2.cmake)
  include(expat.cmake)
  include(ffi.cmake)
  include(ssl.cmake)
  include(xz.cmake)
  include(zlib.cmake)

  ExternalProject_Add(python
  URL ${python_url}
  URL_HASH SHA256=${python_sha256}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} LDFLAGS=${LDFLAGS}
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 15
  DEPENDS "bzip2;expat;ffi;ssl;xz;zlib"
  )

endif()
