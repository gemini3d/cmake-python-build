# xz for python lzma module
# We don't find liblzma because some systems e.g. MacOS have system lzma incompatible with Python build.
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

include(ExternalProject)

string(JSON xz_url GET ${json_meta} xz git)
string(JSON xz_tag GET ${json_meta} xz tag)


set(xz_build_system cmake)

if(xz_build_system STREQUAL cmake)

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

else()

  set(xz_args
  --prefix=${CMAKE_INSTALL_PREFIX}
  --disable-doc
  CC=${CC}
  )

  ExternalProject_Add(xz
  URL ${xz_url}
  URL_HASH SHA256=${xz_sha256}
  CONFIGURE_COMMAND <SOURCE_DIR>/configure ${xz_args} CFLAGS=${CMAKE_C_FLAGS} LDFLAGS=${LDFLAGS}
  BUILD_COMMAND ${MAKE_EXECUTABLE} -j
  INSTALL_COMMAND ${MAKE_EXECUTABLE} -j install
  TEST_COMMAND ""
  CONFIGURE_HANDLED_BY_BUILD ON
  INACTIVITY_TIMEOUT 15
  )

endif()
