find_path(UUID_INCLUDE_DIR
NAMES uuid.h
PATH_SUFFIXES uuid
)

if(UUID_INCLUDE_DIR)
  message(STATUS "UUID header found ${UUID_INCLUDE_DIR}")
else()
  message(STATUS "UUID is missing")
  if(NOT APPLE)
    message(STATUS "apt install uuid-dev  or  dnf install libuuid-devel")
  endif()
endif()


find_path(READLINE_INCLUDE_DIR
NAMES readline.h
PATH_SUFFIXES readline
)

if(READLINE_INCLUDE_DIR)
  message(STATUS "Readline header found ${READLINE_INCLUDE_DIR}")
else()
  message(STATUS "Readline is missing")
  message(STATUS "apt install libreadline-dev  or  dnf install readline-devel  or  brew install readline")
endif()
