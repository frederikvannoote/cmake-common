# Create an SDK package containing all installed files.

add_custom_target(sdk
    ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target install DESTDIR=${CMAKE_BINARY_DIR}/sdk
    COMMAND ${CMAKE_COMMAND} -E tar "cfvz" "sdk.tar.gz" "${CMAKE_INSTALL_PREFIX}"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    COMMENT "Packaging artefacts..."
    VERBATIM)
