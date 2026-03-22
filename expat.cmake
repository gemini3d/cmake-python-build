# installs Expat

set(EXPAT_BUILD_DOCS OFF)
set(EXPAT_BUILD_EXAMPLES OFF)
set(EXPAT_BUILD_TESTS OFF)
set(EXPAT_BUILD_TOOLS OFF)

FetchContent_Declare(EXPAT
URL ${expat_url}
SOURCE_SUBDIR expat/
FIND_PACKAGE_ARGS
)

FetchContent_MakeAvailable(EXPAT)

add_custom_target(expat_dep)
if(EXPAT_FOUND)
  add_dependencies(expat_dep EXPAT::EXPAT)
else()
  add_dependencies(expat_dep expat::expat)
endif()
