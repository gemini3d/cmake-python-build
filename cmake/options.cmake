option(find "search for packages" on)

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)

if(CMAKE_GENERATOR STREQUAL "Ninja Multi-Config")
  set(EXTPROJ_GEN "Ninja")
else()
  set(EXTPROJ_GEN ${CMAKE_GENERATOR})
endif()

cmake_path(SET CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/Modules)

if(NOT CC)
  if(DEFINED ENV{CC})
    set(CC $ENV{CC})
  else()
    cmake_path(GET CMAKE_C_COMPILER FILENAME CC)
  endif()
endif()
# autotools can be confused if generic CC=cc or CXX=c++ is used
if(CC STREQUAL cc)
  unset(CC)
endif()
# autotools can be confused if compiler version number is included e.g. gcc-11
if(CC MATCHES "[0-9]+$")
  unset(CC)
endif()

if(NOT CXX)
  if(DEFINED ENV{CXX})
    set(CXX $ENV{CXX})
  else()
    cmake_path(GET CMAKE_CXX_COMPILER FILENAME CXX)
  endif()
endif()
if(CXX STREQUAL c++)
  unset(CXX)
endif()
if(CXX MATCHES "[0-9]+$")
  unset(CXX)
endif()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

# exclude Conda from search
if(DEFINED ENV{CONDA_PREFIX})
  set(ignore_path
    $ENV{CONDA_PREFIX} $ENV{CONDA_PREFIX}/Library $ENV{CONDA_PREFIX}/Scripts $ENV{CONDA_PREFIX}/condabin
    $ENV{CONDA_PREFIX}/bin $ENV{CONDA_PREFIX}/lib $ENV{CONDA_PREFIX}/include
    $ENV{CONDA_PREFIX}/Library/bin $ENV{CONDA_PREFIX}/Library/lib $ENV{CONDA_PREFIX}/Library/include
  )
  list(APPEND CMAKE_IGNORE_PATH ${ignore_path})
endif()


if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  message(FATAL_ERROR "Please define an install location like
  cmake -B build -DCMAKE_INSTALL_PREFIX=~/mylibs")
endif()
