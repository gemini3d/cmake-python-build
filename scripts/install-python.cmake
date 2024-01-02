# Download Windows executable

cmake_minimum_required(VERSION 3.19)

include(FetchContent)

option(CMAKE_TLS_VERIFY "verify TLS certificates" on)

if(NOT WIN32)
  message(FATAL_ERROR "Embedded Python downloader is Windows-only")
endif()

if(NOT python_version)
  file(READ ${CMAKE_CURRENT_LIST_DIR}/../cmake/libraries.json json_meta)
  string(JSON python_version GET ${json_meta} "python" "version")
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

# --- so Python can find libs
string(REGEX MATCH "(^[0-9]+)\\.([0-9]+)" python_version_short ${python_version})
set(python_version_short ${CMAKE_MATCH_1}${CMAKE_MATCH_2})

find_file(pth
NAMES python${python_version_short}._pth
HINTS ${prefix}
NO_DEFAULT_PATH
REQUIRED)

file(RENAME ${pth} ${prefix}/python${python_version_short}.pth)

set(pth ${prefix}/python${python_version_short}.pth)

# --- verify
find_program(python_exe
NAMES python3 python
HINTS ${prefix}
NO_DEFAULT_PATH
)
if(NOT python_exe)
  message(FATAL_ERROR "failed to install Python ${python_version} to ${prefix}")
endif()

# --- add paths to Python
file(APPEND "${pth}" "${prefix}/Lib\n")

# --- pip
file(DOWNLOAD https://bootstrap.pypa.io/get-pip.py ${prefix}/get-pip.py)

execute_process(COMMAND ${python_exe} ${prefix}/get-pip.py)


get_filename_component(bindir ${python_exe} DIRECTORY)
message(STATUS "installed Python ${python_version} to ${bindir}")
