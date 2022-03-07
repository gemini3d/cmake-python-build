# install bzip2, needed for Python xarray/pandas

if(find)
  find_package(BZip2)
endif()

if(BZIP2_FOUND)
  add_custom_target(bzip2)
  return()
endif()

include(FetchContent)

string(JSON bzip2_url GET ${json_meta} bzip2 url)
string(JSON bzip2_sha256 GET ${json_meta} bzip2 sha256)


FetchContent_Declare(bz2
URL ${bzip2_url}
URL_HASH SHA256=${bzip2_sha256}
UPDATE_DISCONNECTED true  # avoid constant rebuild
)

FetchContent_Populate(bz2)

add_library(bzip2
${bz2_SOURCE_DIR}/blocksort.c
${bz2_SOURCE_DIR}/huffman.c
${bz2_SOURCE_DIR}/crctable.c
${bz2_SOURCE_DIR}/randtable.c
${bz2_SOURCE_DIR}/compress.c
${bz2_SOURCE_DIR}/decompress.c
${bz2_SOURCE_DIR}/bzlib.c
)
target_compile_definitions(bzip2 PRIVATE -D_FILE_OFFSET_BITS=64)
set_target_properties(bzip2 PROPERTIES POSITION_INDEPENDENT_CODE true)
