# Add manifest: executables may require administrative privileges.

macro(add_manifest PROJECT TYPE)
if(CMAKE_BUILD_TYPE MATCHES Release)
    if(WIN32 AND NOT UNIX)
        # Search for the mt binary
        find_program(MT_TOOL NAMES mt PATHS "C:/Program Files/Microsoft SDKs/Windows/v7.1/Bin/" "C:/Program Files (x86)/Windows Kits/8.1/bin/x86")
        # Get the full output name for the target
        set(OUTPUT_FILE_PATH $<TARGET_FILE:${PROJECT}>)

        if(MT_TOOL)
            # select type
            if(${TYPE} STREQUAL "LIB" OR ${TYPE} STREQUAL "QMLLIB")
                set(MANIFEST_FILE_IN ${CMAKE_CURRENT_LIST_DIR}/dll.manifest.in)
                set(MANIFEST_FILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.dll.manifest)
            elseif(${TYPE} STREQUAL "BIN")
                set(MANIFEST_FILE_IN ${CMAKE_CURRENT_LIST_DIR}/exe.manifest.in)
                set(MANIFEST_FILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.exe.manifest)
            endif()

            # fill in the appropriate information into dll.manifest
            configure_file(${MANIFEST_FILE_IN} ${MANIFEST_FILE_OUT})

            add_custom_command(
                TARGET ${PROJECT}
                POST_BUILD
                COMMAND ${MT_TOOL} -manifest ${MANIFEST_FILE_OUT} -outputresource:${OUTPUT_FILE_PATH};#1
                WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIRs}
                DEPENDS ${MANIFEST_FILE_OUT}
            )

            # return info
            message(STATUS "Prepared embedded manifest for ${PROJECT_NAME} of type ${TYPE}")

        else()
            message(SEND_ERROR "Manifest creation of ${PROJECT} failed")
        endif()
    endif(WIN32 AND NOT UNIX)
endif(CMAKE_BUILD_TYPE MATCHES Release)
endmacro()

# More info:
# http://blogs.msdn.com/b/cheller/archive/2006/08/24/how-to-embed-a-manifest-in-an-assembly-let-me-count-the-ways.aspx
