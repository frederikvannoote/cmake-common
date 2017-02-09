# Try to find cppcheck tool for Unix platforms
#
# Cache Variables:
#  CPPCHECK_EXECUTABLE
#
# Non-cache variables you might use in your CMakeLists.txt:
#  CPPCHECK_FOUND
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)

find_program(CPPCHECK_EXECUTABLE cppcheck PATHS /usr/local/bin)

set(CPPCHECK_FOUND FALSE CACHE INTERNAL "")

if(CPPCHECK_EXECUTABLE)
    set(CPPCHECK_FOUND TRUE CACHE INTERNAL "")
endif()

mark_as_advanced(CPPCHECK_EXECUTABLE)
