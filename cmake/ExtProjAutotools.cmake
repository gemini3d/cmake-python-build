function(extproj_autotools name url tag config_args)

list(PREPEND config_args
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CC}
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
INSTALL_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} install
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)

endfunction()
