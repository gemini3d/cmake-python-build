# readline

if(find)
  find_library(libreadline NAMES readline)
  if(libreadline)
    message(STATUS "Found Readline: ${libreadline}")
    add_custom_target(readline)
    return()
  endif()
endif()

set(readline_args)

extproj_autotools(readline ${readline_url} "${readline_args}")
