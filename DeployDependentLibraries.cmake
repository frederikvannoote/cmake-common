# On a Windows platform, you need a way to reference to the libraries you need.
# Using this, those libraries are copied along the executable.
#
# Usage:
# target_link_libraries(${TARGET_NAME} PUBLIC ...)
# include(DeployDependentLibraries) # This include goes after your last link_libraries.

if(WIN32)
    # Copy dependent libraries to path of executable
    get_property(libs TARGET ${TARGET_NAME} PROPERTY LINK_LIBRARIES)
    foreach(lib ${libs})
        if(TARGET ${lib})
            # If this is a library, get its transitive dependencies
            get_property(trans TARGET ${lib} PROPERTY INTERFACE_LINK_LIBRARIES)
            foreach(tran ${trans})
                if(TARGET ${tran})
                    get_property(path TARGET ${tran} PROPERTY LOCATION)
                    list(APPEND ${TARGET_NAME}_deplibs ${path})
                endif()
            endforeach()
            get_property(path TARGET ${lib} PROPERTY LOCATION)
            list(APPEND ${TARGET_NAME}_deplibs ${path})
        else()
            list(APPEND ${TARGET_NAME}_deplibs ${lib})
        endif()
    endforeach()

    list(REMOVE_DUPLICATES ${TARGET_NAME}_deplibs)

    # Replace all entries ending on .lib to .dll
    foreach(lib ${${TARGET_NAME}_deplibs})
        STRING(REGEX REPLACE "lib$" "dll" _replaced_lib ${lib})
        if (DEFINED _replaced_lib)
            list(APPEND _${TARGET_NAME}_deplibs ${_replaced_lib})
        else()
            list(APPEND _${TARGET_NAME}_deplibs ${lib})
        endif()
    endforeach()
    set(${TARGET_NAME}_deplibs ${_${TARGET_NAME}_deplibs})

    foreach(lib ${${TARGET_NAME}_deplibs})
        add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
            COMMAND "${CMAKE_COMMAND}" -E copy_if_different ${lib} ${CMAKE_CURRENT_BINARY_DIR}
            VERBATIM)
    endforeach()
endif()
