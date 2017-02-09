# Try to find gcov tool
#
# Cache Variables:
#  GCOV_EXECUTABLE
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GCOV_FOUND
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)

if(GCOV_EXECUTABLE AND NOT EXISTS "${GCOV_EXECUTABLE}")
    set(GCOV_EXECUTABLE "notfound" CACHE PATH FORCE "")
endif()

IF(NOT CMAKE_COMPILER_IS_GNUCXX AND NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    MESSAGE(WARNING "Compiler is not GNU gcc or Clang!")
    set(GCOV_EXECUTABLE "notfound" CACHE PATH FORCE "")
ELSEIF( NOT CMAKE_BUILD_TYPE STREQUAL "Debug" )
    MESSAGE(WARNING "Code coverage results with an optimized (non-Debug) build may be misleading" )
    set(GCOV_EXECUTABLE "notfound" CACHE PATH FORCE "")
ELSE()
    find_program(GCOV_EXECUTABLE NAMES gcov)
ENDIF(NOT CMAKE_COMPILER_IS_GNUCXX AND NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( Gcov DEFAULT_MSG
                                   GCOV_EXECUTABLE)

mark_as_advanced(GCOV_EXECUTABLE)
