set(terminal_verbose
USES_TERMINAL_DOWNLOAD true
USES_TERMINAL_UPDATE true
USES_TERMINAL_PATCH true
USES_TERMINAL_CONFIGURE true
USES_TERMINAL_BUILD true
USES_TERMINAL_INSTALL true
USES_TERMINAL_TEST true
)

function(extproj_cmake name url tag cmake_args subdir)

list(PREPEND args
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
-DBUILD_TESTING:BOOL=false
)

if(url MATCHES ".git$")
  set(download_params GIT_REPOSITORY ${url} GIT_TAG ${tag} GIT_SHALLOW true)
else()
  set(download_params URL ${url})
endif()

ExternalProject_Add(${name}
${download_params}
CMAKE_ARGS ${args}
TLS_VERIFY true
INACTIVITY_TIMEOUT 60
CONFIGURE_HANDLED_BY_BUILD true
TEST_COMMAND ""
SOURCE_SUBDIR ${subdir}
${terminal_verbose}
)

endfunction()
