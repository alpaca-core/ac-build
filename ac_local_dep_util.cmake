# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#

function(add_ac_local acLocalVersion)
    if(NOT TARGET ac::local)
        if(projectIsSubdir OR projectIsStandalone OR projectIsDeployRoot)
            CPMAddPackage(
                NAME ac-local
                VERSION ${acLocalVersion}
                SYSTEM FALSE # not system, so that it's installable
                GITHUB_REPOSITORY alpaca-core/ac-local
                OPTIONS
                    "AC_LOCAL_BUILD_TOOLS=${projectIsDeployRoot}"
                    "AC_LOCAL_BUILD_TESTS=${projectIsDeployRoot}"
            )
            set(ac-local_ROOT "${ac-local_SOURCE_DIR}")
        elseif(projectIsMonoRoot)
            add_subdirectory(../ac-local ac-local)
            set(ac-local_ROOT "${CMAKE_CURRENT_BINARY_DIR}/ac-local")
        elseif(projectIsMonoComponent OR projectIsDeployComponent)
            find_package(ac-local ${acLocalVersion} REQUIRED)
        endif()
    endif()

    if(NOT ac-local_VERSION VERSION_EQUAL acLocalVersion)
        message(FATAL_ERROR "ac-local version mismatch. Expected ${acLocalVersion}. Got ${ac-local_VERSION}")
    endif()
endfunction()
