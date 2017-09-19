find_package(Cppcheck)

if(CPPCHECK_FOUND)
    file(GLOB_RECURSE CPPCHECK_FILES RELATIVE ${CMAKE_SOURCE_DIR} *.cpp *.h)

    if(NOT TARGET cppcheck)
        add_custom_target(cppcheck)
    endif()
    add_custom_target(cppcheck-${PROJECT_BASE_NAME}
        COMMAND ${CPPCHECK_EXECUTABLE} "--force" "--quiet" "--error-exitcode=1" "--language=c++" ${CPPCHECK_FILES}
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMENT "Running cppcheck..."
        VERBATIM)
    add_dependencies(cppcheck-${PROJECT_BASE_NAME} cppcheck)
endif()
