# Download Windows executable

cmake_minimum_required(VERSION 3.11...3.27)

include(FetchContent)

set(CMAKE_TLS_VERIFY true)

if(NOT WIN32)
  message(FATAL_ERROR "Embedded Python downloader is Windows-only")
endif()

if(NOT python_version)
  set(python_version 3.11.5)
endif()

if(NOT prefix)
  get_filename_component(prefix ~/python-${python_version} ABSOLUTE)
endif()

set(arch $ENV{PROCESSOR_ARCHITECTURE})

if(arch STREQUAL "ARM64")
  set(pyarch arm64)
elseif(arch STREQUAL "AMD64")
  set(pyarch amd64)
elseif(arch STREQUAL "x86")
  set(pyarch win32)
else()
  message(FATAL_ERROR "unknown arch: ${arch}")
endif()

if(NOT python_url)
  # omit "rc*" from the url dir
  string(REGEX REPLACE "rc[0-9]+$" "" python_url_dir "${python_version}")
  set(python_url https://www.python.org/ftp/python/${python_url_dir}/python-${python_version}-embed-${pyarch}.zip)
endif()

message(STATUS "Python ${python_version}  ${python_url}")
message(STATUS "Python ${python_version}  ${prefix}")

set(FETCHCONTENT_QUIET false)

FetchContent_Populate(cmake
URL ${python_url}
TLS_VERIFY ${CMAKE_TLS_VERIFY}
UPDATE_DISCONNECTED true
INACTIVITY_TIMEOUT 60
)

file(MAKE_DIRECTORY ${prefix})
file(COPY ${cmake_SOURCE_DIR}/ DESTINATION ${prefix})

# --- verify
find_program(python_exe
NAMES python3 python
HINTS ${prefix}
NO_DEFAULT_PATH
NO_CACHE
)
if(NOT python_exe)
  message(FATAL_ERROR "failed to install Python ${python_version} to ${prefix}")
endif()

get_filename_component(bindir ${python_exe} DIRECTORY)
message(STATUS "installed Python ${python_version} to ${bindir}")
