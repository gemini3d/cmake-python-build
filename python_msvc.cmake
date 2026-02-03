# https://pythondev.readthedocs.io/windows.html

if(NOT MSVC)
  message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
endif()

set(python_args)

if(python_jit AND python_version VERSION_GREATER_EQUAL "3.13")
  list(APPEND python_args --experimental-jit)
endif()

ExternalProject_Add(python
URL ${python_url}
CONFIGURE_COMMAND ""
BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat ${python_args}
INSTALL_COMMAND <SOURCE_DIR>/python.bat <SOURCE_DIR>/PC/layout --preset-default --copy "${CMAKE_INSTALL_PREFIX}"
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)
# https://discuss.python.org/t/windows-install-from-source-failing/25389/4
# --precompile causes problem with script hard-coded temporary directory
