# Try to find gcovr tool
#
# Cache Variables:
#  GCOVR_EXECUTABLE
#
# Non-cache variables you might use in your CMakeLists.txt:
#  GCOVR_FOUND
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)
#  FindPythonInterp
#  FindGcov

if(GCOVR_EXECUTABLE AND NOT EXISTS "${GCOVR_EXECUTABLE}")
    set(GCOVR_EXECUTABLE "notfound" CACHE PATH FORCE "")
endif()
find_program(GCOVR_EXECUTABLE NAMES gcovr)
find_package(PythonInterp)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args( Gcovr DEFAULT_MSG
								   GCOVR_EXECUTABLE
                                   PYTHONINTERP_FOUND)

mark_as_advanced(GCOVR_EXECUTABLE)