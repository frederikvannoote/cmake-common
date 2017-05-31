#####################################################
# Start of configuration                            #
# Lines below should not be touched in normal cases #
#####################################################

#=======================================
# Set some variables to be used later on
#=======================================
set(PROJECT_NAME ${PROJECT_NAME_PREFIX}${PROJECT_BASE_NAME})
set(TARGET_NAME ${PROJECT_BASE_NAME})
set(PROJECT_NAMESPACE ${PROJECT_NAME_PREFIX}${SO_VERSION})
set(INSTALL_DIRECTORY_NAME ${PROJECT_NAME}/${PROJECT_NAME_PREFIX}${SO_VERSION})
set(CMAKE_DIRECTORY_NAME ${PROJECT_NAME_PREFIX}${SO_VERSION}${PROJECT_BASE_NAME})
set(PACKAGE_NAME ${PROJECT_NAME_PREFIX}${SO_VERSION}${PROJECT_BASE_NAME})
set(MODULE_NAME ${PROJECT_NAME})
#base name used for cmake config files:
#<CMAKE_CONFIG_FILE_BASE_NAME>Config.cmake
#<CMAKE_CONFIG_FILE_BASE_NAME>ConfigVersion.cmake
#<CMAKE_CONFIG_FILE_BASE_NAME>Targets.cmake
#<CMAKE_CONFIG_FILE_BASE_NAME>Targets_noconfig.cmake
set(CMAKE_CONFIG_FILE_BASE_NAME ${PROJECT_NAME_PREFIX}${SO_VERSION}${PROJECT_BASE_NAME})

set(LIB_INSTALL_DIR lib/${INSTALL_DIRECTORY_NAME})
set(INCLUDE_INSTALL_DIR include/${INSTALL_DIRECTORY_NAME})
set(BIN_INSTALL_DIR bin)
set(CMAKE_INSTALL_DIR lib/cmake/${CMAKE_DIRECTORY_NAME})

project(${PROJECT_NAME})

message(STATUS "Libraries will be installed to: ${CMAKE_INSTALL_PREFIX}/${LIB_INSTALL_DIR}")
message(STATUS "Header files will be installed to: ${CMAKE_INSTALL_PREFIX}/${INCLUDE_INSTALL_DIR}")
message(STATUS "Executables will be installed in: ${CMAKE_INSTALL_PREFIX}/${BIN_INSTALL_DIR}")
message(STATUS "CMake config-files will be written to: ${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DIR}")
message(STATUS "${PROJECT_NAME} import target: ${PROJECT_NAMESPACE}::${TARGET_NAME}")
message(STATUS "Building ${PROJECT_NAME} ${FULL_VERSION}-b${BUILD_NUMBER} in ${CMAKE_BUILD_TYPE} mode")
