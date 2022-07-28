# xz for python lzma module
# We don't find liblzma because some systems e.g. MacOS have system lzma incompatible with Python build.
# LZMA is important to some popular Python scientific packages, so we want to be sure it will work.

include(ExternalProject)

string(JSON xz_url GET ${json_meta} xz url)
string(JSON xz_tag GET ${json_meta} xz tag)

set(xz_cmake_args)

extproj_cmake(xz ${xz_url} ${xz_tag} "${xz_cmake_args}" "")
