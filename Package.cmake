# Create an SDK package containing all installed files.

add_custom_target(sdk
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_INSTALL_PREFIX} ${CMAKE_COMMAND} -E tar "cfz" "${CMAKE_BINARY_DIR}/sdk.tar.gz" --files-from=${CMAKE_BINARY_DIR}/install_manifest.txt
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMENT "Packaging artefacts into ${CMAKE_BINARY_DIR}/sdk.tar.gz ..."
    VERBATIM)
add_dependencies(sdk install)
