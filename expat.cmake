# installs Expat

if(find)
  find_package(EXPAT)
  if(EXPAT_FOUND)
    add_custom_target(expat)
    return()
  endif()
endif()

set(expat_args
-DEXPAT_BUILD_DOCS:BOOL=false
-DEXPAT_BUILD_EXAMPLES:BOOL=false
-DEXPAT_BUILD_TESTS:BOOL=false
-DEXPAT_BUILD_TOOLS:BOOL=false
)

extproj_cmake(expat ${expat_url} "${expat_args}" "expat")
