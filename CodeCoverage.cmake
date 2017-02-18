# Enable Code Coverage
#
# USAGE:
# 1. Add the following line to your CMakeLists.txt:
#      INCLUDE(CodeCoverage)
#
# 2. Build a Debug build:
#	 Add the following option: -DCODE_COVERAGE=True
#
# 3. Run the application(s) where you want to analyse the coverage
#
# 4. Generate the report by calling one of these targets:
#    - coverage-html (HTML format)
#    - coverage-xml (cobertura XML format)
#
# Requirements: gcov and gcovr

function(ENABLE_CODE_COVERAGE)
    if(NOT CMAKE_COMPILER_IS_GNUCXX AND NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        message(WARNING "Compiler is not GNU gcc or Clang! Code coverage disabled.")
    elseif( NOT CMAKE_BUILD_TYPE STREQUAL "Debug" )
        message(FATAL "Code coverage results with an optimized (non-Debug) build may be misleading. Code coverage will not run." )
    else()
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -fprofile-arcs -ftest-coverage")
        if (CMAKE_COMPILER_IS_GNUCXX AND NOT UNIX)
            link_libraries(debug gcov)
        endif(CMAKE_COMPILER_IS_GNUCXX AND NOT UNIX)
        if (NOT WIN32)
            set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
        endif (NOT WIN32)

        set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG} PARENT_SCOPE)

        message(STATUS "Code Coverage Enabled")
    endif()
endfunction()

option(CODE_COVERAGE "Code coverage" OFF)
if(CODE_COVERAGE)
    find_package(Gcov REQUIRED)
    find_package(Lcov REQUIRED)

    enable_code_coverage()

    file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/coverage)

    add_custom_target("coverage-report")
    add_custom_command(TARGET "coverage-report"
        COMMAND ${LCOV_EXECUTABLE} --quiet --capture --directory . --base-directory ${CMAKE_SOURCE_DIR} --no-external -o coverage.info
        COMMAND ${LCOV_EXECUTABLE} --quiet --remove coverage.info \*moc_\* -o coverage.info
        COMMAND ${LCOV_EXECUTABLE} --quiet --remove coverage.info \*.moc -o coverage.info
        COMMAND ${LCOV_EXECUTABLE} --quiet --remove coverage.info \*tst_\* -o coverage.info
        COMMAND ${LCOV_EXECUTABLE} --quiet --remove coverage.info \*qrc_\* -o coverage.info
        COMMAND ${LCOV_EXECUTABLE} --list coverage.info
        COMMAND ${LCOV_EXECUTABLE} --summary coverage.info
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Create code coverage report"
        VERBATIM)

    add_custom_target("coverage-html" DEPENDS "coverage-report")
    add_custom_command(TARGET "coverage-html"
        COMMAND ${GENHTML_EXECUTABLE} coverage.info --show-details -o coverage
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Create code coverage html report"
        VERBATIM)

endif(CODE_COVERAGE)
