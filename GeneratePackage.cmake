# CMake helper to generate a cmake module package

set(DEPENDENT_PACKAGES ${${TARGET_NAME}_DEPENDENT_PACKAGES})
set(TARGET_INCLUDE_INSTALL_DIRS ${${TARGET_NAME}_INCLUDE_DIRS} ${CMAKE_BINARY_DIR}/local-exports/include)

set_target_properties(${TARGET_NAME} PROPERTIES
  VERSION ${FULL_VERSION}
  SOVERSION ${SO_VERSION}
  PUBLIC_HEADER "${${TARGET_NAME}_PUBLIC_HEADERS}"
  PRIVATE_HEADER "${${TARGET_NAME}_PRIVATE_HEADERS}"
)

################################################################
# Create and export config packages for usage within this tree #
################################################################

# We configure our template. The template is described later.
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
  ${CMAKE_BINARY_DIR}/local-exports/${CMAKE_CONFIG_FILE_BASE_NAME}Config.cmake
  INSTALL_DESTINATION ${CMAKE_SOURCE_DIR}
)
unset(TARGET_INCLUDE_INSTALL_DIRS)

# This file is included in our template:
export(TARGETS ${TARGET_NAME}
  FILE "${CMAKE_BINARY_DIR}/local-exports/${CMAKE_CONFIG_FILE_BASE_NAME}Targets.cmake"
  NAMESPACE ${PROJECT_NAMESPACE}::
)

##############################################
# Create, export and install config packages #
##############################################

# Create config file
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/config.cmake.in
  ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}Config.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_DIR}
  PATH_VARS INCLUDE_INSTALL_DIR GLOBAL_INCLUDE_INSTALL_DIR
)

# Create a config version file
write_basic_package_version_file(
  ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}ConfigVersion.cmake
  VERSION ${FULL_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Create import targets
install(TARGETS ${TARGET_NAME} EXPORT ${TARGET_NAME}Targets
  RUNTIME DESTINATION ${BIN_INSTALL_DIR}
  LIBRARY DESTINATION ${LIB_INSTALL_DIR}
  ARCHIVE DESTINATION ${LIB_INSTALL_DIR}
  PUBLIC_HEADER DESTINATION ${INCLUDE_INSTALL_DIR}
  PRIVATE_HEADER DESTINATION ${INCLUDE_INSTALL_DIR}/private
)

# Export the import targets
install(EXPORT ${TARGET_NAME}Targets
  FILE "${CMAKE_CONFIG_FILE_BASE_NAME}Targets.cmake"
  NAMESPACE ${PROJECT_NAMESPACE}::
  DESTINATION ${CMAKE_INSTALL_DIR}
)

# Now install the 3 config files
install(FILES ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}Config.cmake
              ${CMAKE_BINARY_DIR}/${CMAKE_CONFIG_FILE_BASE_NAME}ConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_DIR}
)

# Create and install a global module include file
# This makes it possible to include all header files of the module by using
# #include <${PROJECT_NAME}>
set(GLOBAL_HEADER_FILE ${CMAKE_BINARY_DIR}/${PROJECT_NAME_PREFIX}${SO_VERSION}${PROJECT_BASE_NAME})
file(WRITE ${GLOBAL_HEADER_FILE} "//Includes all headers of ${PROJECT_NAME}\n\n")

foreach(header ${${TARGET_NAME}_PUBLIC_HEADERS})
  get_filename_component(header_filename ${header} NAME)
  file(APPEND ${GLOBAL_HEADER_FILE} "#include \"${PROJECT_NAME_PREFIX}${PROJECT_BASE_NAME}/${header_filename}\"\n")
endforeach()

install(FILES ${GLOBAL_HEADER_FILE} DESTINATION ${GLOBAL_INCLUDE_INSTALL_DIR})

# Create and install a global module include file for internal use
# This makes it possible to include all header files of the module by using
# #include <${PROJECT_NAME}>
set(GLOBAL_HEADER_FILE ${CMAKE_BINARY_DIR}/local-exports/include/${PROJECT_NAME})
file(WRITE ${GLOBAL_HEADER_FILE} "//Includes all headers of ${PROJECT_NAME}\n\n")

foreach(header ${${TARGET_NAME}_PUBLIC_HEADERS})
  get_filename_component(header_filename ${header} NAME)
  file(APPEND ${GLOBAL_HEADER_FILE} "#include \"${header_filename}\"\n")
endforeach()
