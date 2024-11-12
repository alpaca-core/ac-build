# Copyright (c) Alpaca Core
# SPDX-License-Identifier: MIT
#

# must be macro, so that set values propagate to parent scope
macro(init_ac_plugin_option name)
    option(BUILD_AC_${name}_PLUGIN "${CMAKE_PROJECT_NAME}: build AC Local plugin" ${pluginDefault})
    if(BUILD_AC_${name}_PLUGIN)
        set(BUILD_SHARED_LIBS OFF)
        set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    endif()
endmacro()
