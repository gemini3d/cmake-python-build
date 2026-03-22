# install bzip2, needed for Python xarray/pandas

set(ENABLE_APP false)
set(ENABLE_DOCS false)
set(ENABLE_EXAMPLES false)
set(ENABLE_TESTS false)
set(ENABLE_SHARED_LIB true)
set(ENABLE_STATIC_LIB false)

if(NOT DEFINED CMAKE_POLICY_VERSION_MINIMUM)
  set(CMAKE_POLICY_VERSION_MINIMUM ${CMAKE_MINIMUM_REQUIRED_VERSION})
endif()

FetchContent_Declare(BZip2
  URL ${bzip2_url}
  FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(BZip2)

add_custom_target(bzip2_dep)
if(BZIP2_FOUND)
  add_dependencies(bzip2_dep BZip2::BZip2)
else()
   add_dependencies(bzip2_dep bz2)
endif()
