# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#

# must be macro, so that set values propagate to parent scope
macro(init_ac_local_plugin_option name)
    option(BUILD_AC_${name}_PLUGIN "${CMAKE_PROJECT_NAME}: build AC Local plugin" ${pluginDefault})
    if(BUILD_AC_${name}_PLUGIN)
        set(BUILD_SHARED_LIBS OFF)
        set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    endif()
endmacro()

function(add_ac_local_plugin)
    cmake_parse_arguments(ARG "" "NAME" "SOURCES;LIBRARIES" ${ARGN})

    set(targetName aclp-${ARG_NAME})

    add_library(${targetName} MODULE
        ${ARG_SOURCES}
    )
    if(NOT WIN32)
        target_compile_options(${targetName} PRIVATE
            -fvisibility=hidden
            -fvisibility-inlines-hidden
        )
    endif()
    target_link_libraries(${targetName} PRIVATE
        ac::local
        ac::jalog
        ${ARG_LIBRARIES}
    )

    string(MAKE_C_IDENTIFIER ${ARG_NAME} nameSym)

    configure_file(
        "${AC_LOCAL_CMAKE_LIB_DIR}/plugin-version.in.h"
        version.h
        @ONLY
    )
    target_include_directories(${targetName} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")

    configure_file(
        "${AC_LOCAL_CMAKE_LIB_DIR}/plugin-dir.in.h"
        ${targetName}-dir.h
        @ONLY
    )
    add_library(${targetName}-dir INTERFACE)
    add_library(ac-dev::${targetName}-dir ALIAS ${targetName}-dir)
    target_include_directories(${targetName}-dir INTERFACE ${CMAKE_CURRENT_BINARY_DIR})

    install(TARGETS ${targetName}
        COMPONENT plugins
        LIBRARY DESTINATION lib/ac-local
    )
endfunction()
