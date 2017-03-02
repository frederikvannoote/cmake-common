# This Cmake file specifies 2 macro's for configuring the output directory of one or multiple libraries

# The macro set_target_output_dir sets the output directory for one specified target
# This macro should be used when defining one target specific output
# @param TARGET is the target project
# @param OUTPUT_DIR is the directory in which the library should be added
macro(set_target_output_dir TARGET OUTPUT_DIR)

    # Output Path for the non-config build (i.e. mingw)
    set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR})
    set_target_properties(${TARGET} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR})
    set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR})

    # Second, for multi-config builds (e.g. msvc)
    foreach( CONFIG ${CMAKE_CONFIGURATION_TYPES} )
        string( TOUPPER ${CONFIG} CONFIG )
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set_target_properties(${TARGET} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set_target_properties(${TARGET} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set_target_properties(${TARGET} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
    endforeach( CONFIG CMAKE_CONFIGURATION_TYPES )

endmacro()

# The macro set_global_output_dir sets the output directory for every target which is build
# in the children cmake files of the caller
# This macro should be used when defining one target specific output
# @param OUTPUT_DIR is the directory in which the underlying libraries should be added
macro(set_global_output_dir OUTPUT_DIR)

    # Output Path for the non-config build (i.e. mingw)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR} )
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR} )
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR} )

    # Second, for multi-config builds (e.g. msvc)
    foreach( CONFIG ${CMAKE_CONFIGURATION_TYPES} )
        string( TOUPPER ${CONFIG} CONFIG )
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CONFIG} ${OUTPUT_DIR} )
    endforeach( CONFIG CMAKE_CONFIGURATION_TYPES )

endmacro()
