# installs CMAKE_INSTALL_PREFIX/bin/libtool[ize]

if(LIBTOOL_EXECUTABLE)
  add_custom_target(libtool)
  return()
endif()

set(libtool_args)


extproj_autotools(libtool ${libtool_url} ${libtool_tag} "${libtool_args}")
