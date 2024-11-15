# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#
option(AC_BUILD_MONO "ac-build: monorepo mode" OFF)
option(AC_BUILD_DEPLOY "ac-build: deploy mode" OFF)
option(AC_BUILD_COMPONENT "ac-build: project is a component" OFF)
mark_as_advanced(AC_BUILD_MONO AC_BUILD_DEPLOY AC_BUILD_COMPONENT)

if(PROJECT_IS_TOP_LEVEL)
    include(setup_ac_top_level_prj)
endif()

if(AC_BUILD_MONO OR AC_BUILD_DEPLOY)
    # root project or a subdir or a component in monorepo or deploy mode
    set(testsDefault ON)
    if(AC_BUILD_DEPLOY AND AC_BUILD_COMPONENT)
        # the examples of a deploy mode component are inaccessible so don't waste time building them
        set(examplesDefault OFF)
    else()
        set(examplesDefault ON)
    endif()
    set(pluginDefault ON)
elseif(AC_BUILD_COMPONENT)
    # component of standalone project
    set(testsDefault OFF)
    set(examplesDefault OFF)
    set(pluginDefault OFF)
elseif(PROJECT_IS_TOP_LEVEL)
    # top level standalone project
    set(testsDefault ON)
    set(examplesDefault ON)
    set(pluginDefault ON)
else()
    # standalone project subdir
    set(testsDefault OFF)
    set(examplesDefault OFF)
    set(pluginDefault OFF)
endif()
