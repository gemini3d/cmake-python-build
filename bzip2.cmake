# install bzip2, needed for Python xarray/pandas

include(FetchContent)

string(JSON bzip2_url GET ${json_meta} bzip2 git)
string(JSON bzip2_tag GET ${json_meta} bzip2 tag)

set(bzip2_args
-DBUILD_UTILS:BOOL=false
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
)

# build
ExternalProject_Add(bzip2
GIT_REPOSITORY ${bzip2_url}
GIT_TAG ${bzip2_tag}
CMAKE_ARGS ${bzip2_args}
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 15
)
