option(find "search for packages" on)
option(BUILD_SHARED_LIBS "build shared libraries" on)

set(CMAKE_TLS_VERIFY ON)

set_property(DIRECTORY PROPERTY EP_UPDATE_DISCONNECTED true)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

cmake_host_system_information(RESULT Ncpu QUERY NUMBER_OF_PHYSICAL_CORES)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/local" CACHE PATH "default install prefix" FORCE)
endif()

# exclude Anaconda directories from search
if(DEFINED ENV{CONDA_PREFIX})
  list(APPEND CMAKE_IGNORE_PREFIX_PATH $ENV{CONDA_PREFIX})
endif()
set(CMAKE_FIND_USE_SYSTEM_ENVIRONMENT_PATH false)

# auto-ignore build dir
file(GENERATE OUTPUT .gitignore CONTENT "*")
