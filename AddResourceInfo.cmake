#CMAKE_CURRENT_LIST_DIR is the directory containing this file when
#referenced here, at top-level scope, when this file is included.
#From within a macro, CMAKE_CURRENT_LIST_DIR is the directory that
#contains the file being processed and invoking the function.  So,
#to use this files directory within a macro, we need to save it at
#top level scope at include time.
set(THIS_FILE_DIR ${CMAKE_CURRENT_LIST_DIR})

#This macro "finishes" the file attributes that should've been already set by the CMakeLists.txt that calls
#add_resource_info. It does this by appending the Git commit hash to the original name (so Windows knows when
#a different version is present), creates the original name in the first place (which should always just be
#the filename), sets the year release to the current year, and appends the architecture to the description.
macro(set_common_attributes_windows PROJECT fileExtension)
get_git_head_revision(GIT_REFSPEC GIT_COMMIT_HASH)
string(TIMESTAMP CURRENT_YEAR "%Y")
if(CMAKE_SIZEOF_VOID_P EQUAL 4)
    set(ARCHITECTURE_DESCRIPTION "32-bit")
else()
    set(ARCHITECTURE_DESCRIPTION "64-bit")
endif()
set( FILE_YEAR_RELEASE ${CURRENT_YEAR})
set( FILE_DESCRIPTION "${FILE_DESCRIPTION} (${ARCHITECTURE_DESCRIPTION})")
set( FILE_ORIGINAL_NAME "${PROJECT}.${fileExtension} ${GIT_COMMIT_HASH}" )
endmacro()

#This macro (currently Windows-only) creates a .RC file that holds all of the application/library's file details. This RC
#file is then appended to the source list for the target.
#
#Here are the following variables the macro expects are properly set before executing:
#FILE_VERSION_MAJOR        - The major version of the file
#FILE_VERSION_MINOR        - The minor version of the file
#FILE_VERSION_PATCH        - The patch version of the file
#FILE_DESCRIPTION          - A description of the file
#FILE_PRODUCT_NAME         - A name of the product. Usually just the fully-expanded name for the application/library.
#(parameter) fileExtension - EXE or DLL?
macro(add_resource_info PROJECT fileExtension)
if(WIN32 AND NOT UNIX)
    set_common_attributes_windows(PROJECT ${fileExtension})
    if(CMAKE_COMPILER_IS_MINGW)
        # First we will try to filter out the mingw bin directory using some list operations
        # Make a list
        STRING(REPLACE "/" ";" QT_LIB_DIR_LIST ${QT_LIBRARY_DIR})

        # Remove the last item
        LIST(REMOVE_ITEM QT_LIB_DIR_LIST "lib")
        # Get the length of the list and the last element
        LIST(LENGTH QT_LIB_DIR_LIST len)
        MATH(EXPR previous "${len}-1")
        LIST(GET QT_LIB_DIR_LIST ${previous} MINGW)

        # add resource.o to the source list of the dll or exe
        list(APPEND ${PROJECT}_SRCS ${CMAKE_CURRENT_BINARY_DIR}/resource.o)

        # fill in the appropriate information into resource.rc
        configure_file(${THIS_FILE_DIR}/resource.rc.in ${CMAKE_CURRENT_BINARY_DIR}/resource.rc)

        # specify how to convert resource.rc into resource.o, using windres.exe
        add_custom_command(
            OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/resource.o
            COMMAND ${QT_LIBRARY_DIR}/../../../Tools/${MINGW}/bin/windres.exe -i resource.rc -o resource.o
            WORKING_DIRECTORY  ${CMAKE_CURRENT_BINARY_DIR}
            DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/resource.rc
        )
        # More info:
        # * http://www.transmissionzero.co.uk/computing/building-dlls-with-mingw/
        #   section "Adding Version Information and Comments to your DLL"
        # * http://msdn.microsoft.com/en-us/library/aa381058.aspx
    elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")

        # add resource.rc to the source list of the dll or exe
        list(APPEND ${PROJECT}_SRCS ${CMAKE_CURRENT_BINARY_DIR}/resource.rc)

        # fill in the appropriate information into resource.rc
        configure_file(${THIS_FILE_DIR}/resource.rc.in ${CMAKE_CURRENT_BINARY_DIR}/resource.rc)
    endif()
endif(WIN32 AND NOT UNIX)
endmacro()

