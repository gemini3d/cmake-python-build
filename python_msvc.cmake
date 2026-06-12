# https://pythondev.readthedocs.io/windows.html

if(NOT MSVC)
  message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
endif()

set(python_args)

if(python_jit AND python_version VERSION_GREATER_EQUAL "3.13")
  list(APPEND python_args --experimental-jit)
endif()

if(CMAKE_SYSTEM_PROCESSOR MATCHES "ARM64")
  list(APPEND python_args -p ARM64)
  #list(APPEND python_args "/p:PlatformToolset=v145")
endif()

if(CMAKE_VERSION VERSION_GREATER_EQUAL "4.2")
  set(_sbom_env BUILD_ENVIRONMENT_MODIFICATION PYTHON_SBOM_SKIP=set:1)
endif()

ExternalProject_Add(python
URL ${python_url}
CONFIGURE_COMMAND ""
BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat ${python_args}
${_sbom_env}
PATCH_COMMAND ${CMAKE_COMMAND} -DSBOM_FILE=<SOURCE_DIR>/Tools/build/generate_sbom.py -P ${CMAKE_CURRENT_LIST_DIR}/scripts/skip_sbom_patch.cmake
INSTALL_COMMAND <SOURCE_DIR>/python.bat <SOURCE_DIR>/PC/layout --preset-default --copy "${CMAKE_INSTALL_PREFIX}"
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)
# https://discuss.python.org/t/windows-install-from-source-failing/25389/4
# --precompile causes problem with script hard-coded temporary directory
