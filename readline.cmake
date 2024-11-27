# readline -- not used because it requires tinfo, part of Ncurses
# just install from package manager
# apt install libreadline-dev
# dnf install readline-devel
# brew install readline

if(find_readline)
  find_library(libreadline NAMES readline)
  if(libreadline)
    message(STATUS "Found Readline: ${libreadline}")
    add_custom_target(readline)
    return()
  else()
    message(STATUS "Readline not found")
  endif()
endif()

set(readline_args)

extproj_autotools(readline ${readline_url} "${readline_args}")
