# Create an SDK package containing all installed files.

if(NOT TARGET sdk)
    add_custom_target(sdk)
endif()
add_custom_target(sdk-${PROJECT_BASE_NAME} ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target install
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_INSTALL_PREFIX} ${CMAKE_COMMAND} -E tar "cfz" "${CMAKE_BINARY_DIR}/sdk.tar.gz" --files-from=${CMAKE_BINARY_DIR}/install_manifest.txt
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMENT "Packaging artefacts into ${CMAKE_BINARY_DIR}/sdk.tar.gz ..."
    VERBATIM)
add_dependencies(sdk-${PROJECT_BASE_NAME} sdk)
