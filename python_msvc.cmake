# https://pythondev.readthedocs.io/windows.html

if(NOT MSVC)
message(FATAL_ERROR "Python building on Windows requires Visual Studio.")
endif()

ExternalProject_Add(python
URL ${python_url}
CONFIGURE_COMMAND ""
BUILD_COMMAND <SOURCE_DIR>/PCBuild/build.bat
INSTALL_COMMAND <SOURCE_DIR>/python.bat <SOURCE_DIR>/PC/layout --preset-default --copy "${CMAKE_INSTALL_PREFIX}"
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)
# https://discuss.python.org/t/windows-install-from-source-failing/25389/4
# --precompile causes problem with script hard-coded temporary directory
