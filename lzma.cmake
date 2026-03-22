# xz for python lzma module
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

set(XZ_DOC false)
set(BUILD_TESTING false)

FetchContent_Declare(LibLZMA
  URL ${lzma_url}
  FIND_PACKAGE_ARGS
)

FetchContent_MakeAvailable(LibLZMA)

add_custom_target(lzma_dep)
if(LibLZMA_FOUND)
  add_dependencies(lzma_dep LibLZMA::LibLZMA)
else()
  add_dependencies(lzma_dep liblzma)
endif()
