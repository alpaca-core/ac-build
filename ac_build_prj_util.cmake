# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#
include_guard(GLOBAL)

function(add_ac_subdir)
    cmake_parse_arguments(ARG "" "NAME;TARGET;VERSION;GITHUB" "" ${ARGN})

    if(NOT TARGET ${ARG_TARGET})
        if(AC_BUILD_COMPONENT)
            find_package(${ARG_NAME} ${ARG_VERSION} REQUIRED)
        elseif(AC_BUILD_MONO)
            add_subdirectory("${CMAKE_SOURCE_DIR}/../${ARG_NAME}" ${ARG_NAME})

            if(NOT ${ARG_NAME}_VERSION VERSION_EQUAL ARG_VERSION)
                message(FATAL_ERROR "${ARG_NAME} version mismatch. Expected ${ARG_VERSION}. Got ${${ARG_NAME}_VERSION}")
            endif()

            set(${ARG_NAME}_ROOT "${CMAKE_CURRENT_BINARY_DIR}/${ARG_NAME}"
                CACHE PATH "ac-build: find_package path to ${ARG_NAME}" FORCE)
        else() # standalone or deploy
            CPMAddPackage(
                NAME ${ARG_NAME}
                VERSION ${ARG_VERSION}
                SYSTEM FALSE # not system, so that it's installable
                GITHUB_REPOSITORY ${ARG_GITHUB}
            )

            if(NOT ${ARG_NAME}_ADDED)
                message(FATAL_ERROR "Adding ac-build project ${ARG_NAME} multiple times")
            endif()

            set(${ARG_NAME}_ROOT "${${ARG_NAME}_BINARY_DIR}"
                CACHE PATH "ac-build: find_package path to ${ARG_NAME}" FORCE)
        endif()
    endif()
endfunction()

macro(add_ac_local acSdkVersion)
    add_ac_subdir(
        NAME alpaca-core-sdk
        TARGET ac::local
        VERSION ${acSdkVersion}
        GITHUB "alpaca-core/alpaca-core-sdk"
    )
endmacro()
