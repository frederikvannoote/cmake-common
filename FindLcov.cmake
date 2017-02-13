# Try to find lcov tool
#
# Cache Variables:
#  LCOV_EXECUTABLE
#  GENHTML_EXECUTABLE
#
# Non-cache variables you might use in your CMakeLists.txt:
#  LCOV_FOUND
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)

if(LCOV_EXECUTABLE AND NOT EXISTS "${LCOV_EXECUTABLE}")
    set(LCOV_EXECUTABLE "notfound" CACHE PATH FORCE "")
endif()

if(GENHTML_EXECUTABLE AND NOT EXISTS "${GENHTML_EXECUTABLE}")
    set(GENHTML_EXECUTABLE "notfound" CACHE PATH FORCE "")
endif()

find_program(LCOV_EXECUTABLE NAMES lcov)
find_program(GENHTML_EXECUTABLE NAMES genhtml)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( Lcov DEFAULT_MSG
                                   LCOV_EXECUTABLE GENHTML_EXECUTABLE)

mark_as_advanced(LCOV_EXECUTABLE GENHTML_EXECUTABLE)
