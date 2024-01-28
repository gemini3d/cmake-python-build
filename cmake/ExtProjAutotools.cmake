function(extproj_autotools name url tag config_args)

list(PREPEND config_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
CFLAGS=${CMAKE_C_FLAGS}
LDFLAGS=${LDFLAGS}
)

if(url MATCHES ".git$")
  set(download_params GIT_REPOSITORY ${url} GIT_TAG ${tag} GIT_SHALLOW true)
else()
  set(download_params URL ${url})
endif()

ExternalProject_Add(${name}
${download_params}
CONFIGURE_COMMAND <SOURCE_DIR>/configure ${config_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)

endfunction()
