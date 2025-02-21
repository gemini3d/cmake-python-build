function(extproj_autotools name url config_args)

list(PREPEND config_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
CXX=${CMAKE_CXX_COMPILER}
CFLAGS=${CMAKE_C_FLAGS}
LDFLAGS=${LDFLAGS}
)

ExternalProject_Add(${name}
URL ${url}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${config_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)

endfunction()
