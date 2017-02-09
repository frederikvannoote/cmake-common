# Enable Code Coverage
#
# USAGE:
# 1. Copy this file into your cmake modules path.
#
# 2. Add the following line to your CMakeLists.txt:
#      INCLUDE(CodeCoverage)
#
# 3. Call the function ENABLE_CODE_COVERAGE
#    This functions sets compiler flags to turn off optimization and enable coverage:
#    SET(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -fprofile-arcs -ftest-coverage")
#
# 4. Build a Debug build:
#	 cmake -DCMAKE_BUILD_TYPE=Debug ..
#	 make
#	 make my_coverage_target
#
# Note: code coverage can only be enabled when in debug build!
#
# Requirements: gcov and gcovr

# Check prereqs
find_package(Gcov)
find_package(Gcovr)

function(ENABLE_CODE_COVERAGE)
    if (GCOV_FOUND AND GCOVR_FOUND)
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g -O0 -fprofile-arcs -ftest-coverage")
        if (CMAKE_COMPILER_IS_GNUCXX AND NOT UNIX)
            link_libraries(debug gcov)
        endif(WIN32 AND NOT UNIX)
        if (NOT WIN32)
            set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC")
        endif (NOT WIN32)

        set(CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG} PARENT_SCOPE)

        message(STATUS "Code Coverage Enabled")
    else()
        message("-- Code Coverage NOT Enabled because gcov and/or gcovr was not found.")
    endif()
endfunction()
