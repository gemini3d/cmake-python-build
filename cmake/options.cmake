option(find "search for packages" on)
option(BUILD_SHARED_LIBS "build shared libraries" on)

set(CMAKE_TLS_VERIFY ON)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

# -- config checks

if(NOT MSVC)
get_property(is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(is_multi_config)
  if(CMAKE_GENERATOR MATCHES "Ninja")
    set(suggest Ninja)
  else()
    set(suggest "Unix Makefiles")
  endif()
  message(FATAL_ERROR "Please use a single configuration generator like:
  cmake -G \"${suggest}\"
  ")
endif()
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
