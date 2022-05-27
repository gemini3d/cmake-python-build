# installs Expat

include(ExternalProject)

if(find)
  find_package(EXPAT)
endif()

if(EXPAT_FOUND)
  add_custom_target(expat)
  return()
endif()

string(JSON expat_url GET ${json_meta} expat url)
string(JSON expat_tag GET ${json_meta} expat tag)

set(expat_args
-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=on
-DCMAKE_BUILD_TYPE=Release
-DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
-DEXPAT_BUILD_DOCS:BOOL=false
-DEXPAT_BUILD_EXAMPLES:BOOL=false
-DEXPAT_BUILD_TESTS:BOOL=false
-DEXPAT_BUILD_TOOLS:BOOL=false
-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
)

ExternalProject_Add(expat
GIT_REPOSITORY ${expat_url}
GIT_TAG ${expat_tag}
GIT_SHALLOW true
TEST_COMMAND ""
CMAKE_ARGS ${expat_args}
CMAKE_GENERATOR ${EXTPROJ_GEN}
SOURCE_SUBDIR expat
CONFIGURE_HANDLED_BY_BUILD ON
INACTIVITY_TIMEOUT 60
)
