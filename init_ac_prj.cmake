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

if(PROJECT_IS_TOP_LEVEL OR AC_BUILD_MONO OR AC_BUILD_DEPLOY)
    # root project or a subdir in monorepo or deploy mode
    set(testsDefault ON)
    set(examplesDefault ON)
    set(pluginDefault ON)
else()
    set(testsDefault OFF)
    set(examplesDefault OFF)
    set(pluginDefault OFF)
endif()
