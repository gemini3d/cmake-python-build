# xz for python lzma module
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

if(find_lzma)
  find_package(LibLZMA)
  if(LIBLZMA_FOUND)
    add_custom_target(xz)
    return()
  endif()
endif()

set(xz_cmake_args
-DXZ_DOC:BOOL=false
-DBUILD_TESTING:BOOL=false
)

extproj_cmake(xz "${lzma_url}" "${xz_cmake_args}" "")
