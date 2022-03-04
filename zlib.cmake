if(find)
  find_package(ZLIB)
endif()

if(ZLIB_FOUND)
  add_custom_target(zlib)
  return()
endif()

set(zlib_cmake_args
-DZLIB_COMPAT:BOOL=on
-DZLIB_ENABLE_TESTS:BOOL=off
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
)

# CMAKE_POSITION_INDEPENDENT_CODE=on is needed for zlib to work with Python, even when using static libs.

string(JSON zlib_url GET ${json_meta} zlib url)
string(JSON zlib_sha256 GET ${json_meta} zlib sha256)

ExternalProject_Add(zlib
URL ${zlib_url}
URL_HASH SHA256=${zlib_sha256}
GIT_SHALLOW true
CMAKE_ARGS ${zlib_cmake_args}
CMAKE_GENERATOR ${EXTPROJ_GEN}
INACTIVITY_TIMEOUT 15
CONFIGURE_HANDLED_BY_BUILD true
TEST_COMMAND ""
)
