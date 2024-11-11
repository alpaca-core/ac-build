# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#
set(AC_LOCAL_CMAKE_LIB_DIR "${CMAKE_CURRENT_LIST_DIR}")

option(AC_MONO_ROOT "project is a monorepo root" OFF)
option(AC_MONO_COMP "project is a monorepo component" OFF)
option(AC_DEPLOY_ROOT "project is a deploy root" OFF)
option(AC_DEPLOY_COMP "project is a deploy component" OFF)
mark_as_advanced(AC_MONO_ROOT AC_MONO_COMP AC_DEPLOY_ROOT AC_DEPLOY_COMP)

if(PROJECT_IS_TOP_LEVEL)
    set(projectIsSubdir NO)
    set(projectIsRoot YES)
    set(projectIsMonoRoot ${AC_MONO_ROOT})
    set(projectIsMonoComponent ${AC_MONO_COMP})
    set(projectIsDeployRoot ${AC_DEPLOY_ROOT})
    set(projectIsDeployComponent ${AC_DEPLOY_COMP})
    if(NOT projectIsMonoRoot AND NOT projectIsMonoComponent
        AND NOT projectIsDeployRoot AND NOT projectIsDeployComponent)
        # standalone if none of the above opinions are set
        set(projectIsStandalone YES)
    endif()
    include(setup_ac_local_prj_root)
else()
    set(projectIsSubdir YES)
    set(projectIsRoot NO)
    set(projectIsStandalone NO)
    set(projectIsMonoRoot NO)
    set(projectIsMonoComponent NO)
    set(projectIsDeployRoot NO)
    set(projectIsDeployComponent NO)
endif()

if(projectIsRoot OR AC_MONO_ROOT OR AC_DEPLOY_ROOT)
    # root project or a subdir of an ac root
    set(testsDefault ON)
    set(toolsDefault ON)
    if(projectIsDeployRoot OR projectIsDeployComponent)
        # don't build examples on deploy
        set(examplesDefault OFF)
    else()
        set(examplesDefault ON)
    endif()
    set(pluginDefault ON)
else()
    set(testsDefault OFF)
    set(toolsDefault OFF)
    set(examplesDefault OFF)
    set(pluginDefault OFF)
endif()
