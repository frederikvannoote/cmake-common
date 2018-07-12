# CMake helper to generate a cmake module package

set(DEPENDENT_PACKAGES ${${TARGET_NAME}_DEPENDENT_PACKAGES})

set_target_properties(${TARGET_NAME} PROPERTIES
  VERSION ${FULL_VERSION}
  SOVERSION ${SO_VERSION}
  PUBLIC_HEADER "${${TARGET_NAME}_PUBLIC_HEADERS}"
  PRIVATE_HEADER "${${TARGET_NAME}_PRIVATE_HEADERS}"
)

##############################################
# Create, export and install config packages #
##############################################

# Create config file
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
  ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}Config.cmake
  INSTALL_DESTINATION ${CMAKE_BINARY_DIR}
  PATH_VARS INCLUDE_INSTALL_DIR GLOBAL_INCLUDE_INSTALL_DIR
)

# Create a config version file
write_basic_package_version_file(
  ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}ConfigVersion.cmake
  VERSION ${FULL_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Create import targets
install(TARGETS ${TARGET_NAME}
  EXPORT ${TARGET_NAME}Targets
  RUNTIME DESTINATION ${BIN_INSTALL_DIR}
  LIBRARY DESTINATION ${LIB_INSTALL_DIR}
  ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
  PUBLIC_HEADER DESTINATION ${INCLUDE_INSTALL_DIR}
  PRIVATE_HEADER DESTINATION ${INCLUDE_INSTALL_DIR}/private
  INCLUDES DESTINATION ${INCLUDE_INSTALL_DIR} include/${INSTALL_DIRECTORY_NAME}
)

# Export the import targets
export(EXPORT ${TARGET_NAME}Targets
  FILE "${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}Targets.cmake"
  NAMESPACE ${PROJECT_NAMESPACE}::
)

# Now install the 3 config files
install(FILES ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}Config.cmake
              ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}ConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_DIR}
)

install(EXPORT ${TARGET_NAME}Targets
  FILE ${CMAKE_CONFIG_FILE_BASE_NAME}Targets.cmake
  NAMESPACE ${PROJECT_NAMESPACE}::
  DESTINATION ${CMAKE_INSTALL_DIR}
)
