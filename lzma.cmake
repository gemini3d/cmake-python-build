# xz for python lzma module
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

include(ExternalProject)

if(find)
  find_package(LibLZMA)
  if(LIBLZMA_FOUND)
    add_custom_target(xz)
    return()
  endif()
endif()

if(CMAKE_GENERATOR MATCHES "Ninja")
  message(WARNING "xz project may fail to build with Ninja. Try GNU Make if xz fails to build with Ninja:
  cmake -Bbuild -G \"Unix Makefiles\"")
endif()

string(JSON xz_url GET ${json_meta} xz url)
string(JSON xz_tag GET ${json_meta} xz tag)

set(xz_cmake_args)

extproj_cmake(xz ${xz_url} ${xz_tag} "${xz_cmake_args}" "")
