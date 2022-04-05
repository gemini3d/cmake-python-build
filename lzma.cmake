# xz for python lzma module
# We don't find liblzma because some systems e.g. MacOS have system lzma incompatible with Python build.
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

include(ExternalProject)

string(JSON xz_url GET ${json_meta} xz url)
string(JSON xz_tag GET ${json_meta} xz tag)


set(xz_cmake_args
-DBUILD_TESTING:BOOL=false
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
)

ExternalProject_Add(xz
GIT_REPOSITORY ${xz_url}
GIT_TAG ${xz_tag}
GIT_SHALLOW true
TEST_COMMAND ""
CMAKE_ARGS ${xz_cmake_args}
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
