# installs OpenSSL CMAKE_INSTALL_PREFIX/lib64/lib{crypto,ssl}.{a,so}

if(find_ssl)
  find_package(OpenSSL)
  if(OPENSSL_FOUND)
    set(ssl_version ${OpenSSL_VERSION})
    add_custom_target(ssl)
    return()
  endif()
endif()

# https://peps.python.org/pep-0644/
if(ssl_version VERSION_LESS 1.1.1)
  message(FATAL_ERROR "OpenSSL version 1.1.1 or later is required by Python >= 3.10.")
endif()

set(ssl_config_args
--openssldir=${CMAKE_INSTALL_PREFIX}
--prefix=${CMAKE_INSTALL_PREFIX}
CC=${CMAKE_C_COMPILER}
)
if(BUILD_SHARED_LIBS)
  list(APPEND ssl_config_args shared)
endif()
# bad options?
# --no-ssl2
# --no-weak-ssl-ciphers

ExternalProject_Add(ssl
URL ${ssl_url}
CONFIGURE_COMMAND <SOURCE_DIR>/config ${ssl_config_args}
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install_sw
TEST_COMMAND ""
CONFIGURE_HANDLED_BY_BUILD ON
${terminal_verbose}
)
