cmake_minimum_required(VERSION 3.19)

if(NOT bindir)
  set(bindir ${CMAKE_CURRENT_LIST_DIR}/build)
endif()
get_filename_component(bindir ${bindir} ABSOLUTE)

if(NOT prefix)
  set(prefix ${bindir}/local)
endif()
get_filename_component(prefix ${prefix} ABSOLUTE)

set(conf_args -DCMAKE_INSTALL_PREFIX:PATH=${prefix})
if(DEFINED find)
  list(APPEND conf_args -Dfind:BOOL=${find})
endif()
if(python_version)
  list(APPEND conf_args -Dpython_version=${python_version})
endif()

execute_process(COMMAND ${CMAKE_COMMAND}
-S${CMAKE_CURRENT_LIST_DIR}
-B${bindir}
${conf_args}
COMMAND_ERROR_IS_FATAL ANY
)

# --- build

execute_process(COMMAND ${CMAKE_COMMAND} --build ${bindir}
COMMAND_ERROR_IS_FATAL ANY
)

# --- test that Python libraries working

execute_process(COMMAND ${CMAKE_CTEST_COMMAND} --test-dir ${bindir} -V
COMMAND_ERROR_IS_FATAL ANY
)
