if(NOT python_version)
  string(JSON python_version GET ${json_meta} "python" "version")
endif()

if(NOT python_url)
  # only major.minor.release url dir
  string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" python_url_dir "${python_version}")
  set(python_url https://www.python.org/ftp/python/${python_url_dir}/Python-${python_version}.tar.xz)
endif()

if(python_url MATCHES ".git$")
  if(NOT python_tag)
    string(JSON python_tag GET ${json_meta} python tag)
  endif()
  set(python_download GIT_REPOSITORY ${python_url} GIT_TAG "${python_tag}" GIT_SHALLOW true)
else()
  set(python_download URL ${python_url})
endif()


if(WIN32)
  # https://pythondev.readthedocs.io/windows.html

  if(NOT MSVC)
    message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
  endif()

  ExternalProject_Add(python
  ${python_download}
  CONFIGURE_COMMAND ""
  BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
  INSTALL_COMMAND <SOURCE_DIR>/python.bat <SOURCE_DIR>/PC/layout --preset-default --copy "${CMAKE_INSTALL_PREFIX}"
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  ${terminal_verbose}
  )
  # https://discuss.python.org/t/windows-install-from-source-failing/25389/4
  # --precompile causes problem with script hard-coded temporary directory

  return()
endif()

# Linux prereqs: https://devguide.python.org/setup/#linux

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

message(STATUS "Python configure args: ${python_args}")
message(STATUS "Python CFLAGS: ${python_cflags}")
message(STATUS "Python LDFLAGS: ${python_ldflags}")

ExternalProject_Add(python
${python_download}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${python_args} CFLAGS=${python_cflags} LDFLAGS=${python_ldflags}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
DEPENDS "bzip2;expat;ffi;readline;ssl;xz;zlib"
${terminal_verbose}
)
