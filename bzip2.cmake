# install bzip2, needed for Python xarray/pandas

include(FetchContent)

string(JSON bzip2_url GET ${json_meta} bzip2 url)
string(JSON bzip2_tag GET ${json_meta} bzip2 tag)

set(bzip2_args
-DBUILD_UTILS:BOOL=false
)

# build
extproj_cmake(bzip2 ${bzip2_url} ${bzip2_tag} "${bzip2_args}" "")
