find_package(Cppcheck)

if(CPPCHECK_FOUND)
    file(GLOB_RECURSE CPPCHECK_FILES RELATIVE ${CMAKE_SOURCE_DIR} *.cpp *.h)

    add_custom_target(cppcheck
        COMMAND ${CPPCHECK_EXECUTABLE} "--force" "--quiet" "--error-exitcode=1" "--language=c++" ${CPPCHECK_FILES}
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        COMMENT "Running cppcheck..."
        VERBATIM)
endif()
