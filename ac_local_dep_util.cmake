# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#

function(add_ac_local_subdir)
    cmake_parse_arguments(ARG "" "NAME;TARGET;VERSION;GITHUB" "" ${ARGN})

    if(NOT TARGET ${ARG_TARGET})
        if(projectIsSubdir OR projectIsStandalone OR projectIsDeployRoot)
            CPMAddPackage(
                NAME ${ARG_NAME}
                VERSION ${ARG_VERSION}
                SYSTEM FALSE # not system, so that it's installable
                GITHUB_REPOSITORY ${ARG_GITHUB}
            )
            set(${ARG_NAME}_ROOT "${${ARG_NAME}_BINARY_DIR}" PARENT_SCOPE)
        elseif(projectIsMonoRoot)
            add_subdirectory("${CMAKE_SOURCE_DIR}/../${ARG_NAME}" ${ARG_NAME})
            set(${ARG_NAME}_ROOT "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}" PARENT_SCOPE)
        elseif(projectIsMonoComponent OR projectIsDeployComponent)
            find_package(${ARG_NAME} ${ARG_VERSION} REQUIRED)
        endif()
    endif()

    if(NOT ${ARG_NAME}_VERSION VERSION_EQUAL ARG_VERSION)
        message(FATAL_ERROR "${ARG_NAME} version mismatch. Expected ${ARG_VERSION}. Got ${${ARG_NAME}_VERSION}")
    endif()
endfunction()

macro(add_ac_local acLocalVersion)
    add_ac_local_subdir(
        NAME ac-local
        TARGET ac::local
        VERSION ${acLocalVersion}
        GITHUB "alpaca-core/ac-local"
    )
endmacro()

function(make_ac_local_plugin_available name)
    if(projectIsDeployComponent)
        # project is a deploy component
        # plugin is assumed to be installed and available
        return()
    endif()
endfunction()
