# install bzip2, needed for Python xarray/pandas

if(find_bzip2)
  find_package(BZip2)
  if(BZIP2_FOUND)
    add_custom_target(bzip2)
    return()
  endif()
endif()


# build
ExternalProject_Add(bzip2
URL ${bzip2_url}
CONFIGURE_COMMAND ""
BUILD_COMMAND ${MAKE_EXECUTABLE} -j${Ncpu} -C <SOURCE_DIR>
INSTALL_COMMAND ${MAKE_EXECUTABLE} -C <SOURCE_DIR> install PREFIX=${CMAKE_INSTALL_PREFIX}
${terminal_verbose}
)
