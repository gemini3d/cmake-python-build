set(ZLIB_COMPAT on)
set(BUILD_TESTING off)
set(ZLIBNG_ENABLE_TESTS off)

# CMAKE_POSITION_INDEPENDENT_CODE=on is needed for zlib to work with Python, even when using static libs.

FetchContent_Declare(ZLIB
  URL ${zlib_url}
  FIND_PACKAGE_ARGS
)
FetchContent_MakeAvailable(ZLIB)

add_custom_target(zlib_dep)
if(ZLIB_FOUND)
  add_dependencies(zlib_dep ZLIB::ZLIB)
else()
  add_dependencies(zlib_dep zlib)
endif()
