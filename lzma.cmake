# xz for python lzma module
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

if(find)
  find_package(LibLZMA)
  if(LIBLZMA_FOUND)
    add_custom_target(xz)
    return()
  endif()
endif()

set(xz_cmake_args)

extproj_cmake(xz "${lzma_url}" "${xz_cmake_args}" "")
