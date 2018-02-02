# Force synchronous PDB writes for Visual Studio
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    add_compile_options("/FS")
endif()

# Set default build type to release with debug info
IF(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   SET(CMAKE_BUILD_TYPE RelWithDebInfo)
ENDIF(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)


if(CMAKE_COMPILER_IS_GNUCXX)
    set(COMPILER_FLAGS
                        "-std=c++11"
                        "-Wall"                             # turn on all warnings
                        "-pedantic"
                        "-Wextra"
                        "-fno-rtti"                         # disable runtime type information
                        "-ffor-scope"
                        "-fuse-cxa-atexit"
                        "-fno-default-inline"
                        "-fvisibility=hidden"               # do not export symbols by default
                        "-fvisibility-inlines-hidden"
                        "-pedantic-errors"
                        "-Wsign-promo"
                        "-Wsign-compare"
                        "-Wnon-virtual-dtor"
                        "-Wold-style-cast"
                        "-Woverloaded-virtual"
                        "-Wswitch"
                        "-Wswitch-default"
                        "-Wswitch-enum"
                        "-Wcast-qual"
                        "-Wcast-align"
                        "-Wuninitialized"
                        "-Wno-float-equal"
                        "-Wlogical-op"
                        "-Wpacked"
                        "-Wredundant-decls"
                        "-Wdisabled-optimization"
                        "-Wdeprecated"
                        "-Wempty-body"
                        "-Wreturn-type"
                        "-Wunused-variable"
                        "-Wno-unknown-pragmas"              # suppress unknown pragma warnings
                        "-Wformat"
                        "-Wunreachable-code"
                        "-mfpmath=sse"                      # needed on Debian 32-bit to get high precision floating point operations
                        "-msse2"                            # needed on Debian 32-bit to get high precision floating point operations

                        "-Weffc++"                          # warnings from Effective C++ book;

                        "-Werror"
                        "-Wformat-nonliteral"               # const char* argumements could not langer be passed due to this entry
#                       "-Winline"                          # gcc on Linux seems to decide frequently not to inline, and warns about it.
#                                                           # We don't need to know about it, since not inlining is not a problem.
#                       "-Wnull-character"                  # not supported by gcc
#                        "-Wshadow"                         # disable shadow warning as gcc generates
                                                            # warnings for parameters with same name
                                                            # as methods in the class.
                                                            # This option is enabled for clang builds,
                                                            # so the 'real' shadow variables will be
                                                            # caught be clang
                        "-Wsign-conversion"
#                       "-Wuseless-cast"
#                       "-Wzero-as-null-pointer-constant"
    )
    if(WIN32)
        # Fix for using LxCan sensor SDK
        # Since LxNative.dll uses stdcall convention, MinGW expects @.. decoration of the exposed functions,
        # which are not present in the DLL.  This MinGW option tells the linker to also look for undecorated
        # functions.
        set(COMPILER_FLAGS "${COMPILER_FLAGS}" "-Wl,--enable-stdcall-fixup")
    endif()

    if (NOT DEFINED ALLOW_EXCEPTIONS)
        option(ALLOW_EXCEPTIONS "Allow exceptions" OFF)
    endif()
    if (NOT ${ALLOW_EXCEPTIONS})
        set(COMPILER_FLAGS "${COMPILER_FLAGS}" "-fno-exceptions")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    set(COMPILER_FLAGS
                        "-stdlib=libc++"
                        "-std=c++11"
                        "-Wall"                             # turn on all warnings
                        "-Wpedantic"
                        "-Wextra"
                        "-Weffc++"                          # turn on warnings from Effective C++ handbook
                        "-fno-rtti"                         # disable runtime type information
                        "-ffor-scope"
                        "-fuse-cxa-atexit"
                        "-fvisibility=hidden"               # do not export symbols by default
                        "-fvisibility-inlines-hidden"
                        "-pedantic"                         # warn about language extensions
                        "-pedantic-errors"                  # treat language extension warnings as errors
                        "-Wsign-promo"
                        "-Wsign-compare"
                        "-Wnon-virtual-dtor"
                        "-Wold-style-cast"
                        "-Woverloaded-virtual"
                        "-Wint-to-void-pointer-cast"
                        "-Wswitch"
                        "-Wswitch-default"
                        "-Wswitch-enum"
                        "-Wcast-qual"
                        "-Wcast-align"
                        "-Wuninitialized"
                        "-Wno-float-equal"
                        "-Wshadow"
                        "-Wpacked"
                        "-Wredundant-decls"
                        "-Wdisabled-optimization"
                        "-Wdeprecated"
                        "-Wdeprecated-declarations"
                        "-Wempty-body"
                        "-Wbitwise-op-parentheses"
                        "-Wlogical-op-parentheses"
                        "-Wold-style-cast"
                        "-Wold-style-definition"
                        "-Wout-of-line-declaration"
                        "-Waddress-of-temporary"
                        "-Wbool-conversions"
                        "-Wbad-function-cast"
                        "-Wbind-to-temporary-copy"
                        "-Wdiv-by-zero"
                        "-Wheader-hygiene"
                        "-Wnull-dereference"
                        "-Widiomatic-parentheses"
                        "-Wparentheses"
                        "-Winitializer-overrides"
                        "-Wint-to-pointer-cast"
                        "-Wpointer-to-int-cast"
                        "-Wpointer-arith"
                        "-Wmissing-braces"
                        "-Wmissing-field-initializers"
                        "-Wnonnull"
                        "-Woverflow"
                        "-Wshorten-64-to-32"
                        "-Wno-used-but-marked-unused"
                        "-Wreturn-type"
                        "-Wnull-character"
                        "-Wunused-variable"
                        "-Wselector"
                        "-Wno-unknown-pragmas"              # suppress unknown pragma warnings
                        "-Wno-gnu-zero-variadic-macro-arguments" # suppress need of at least one argument for '...' parameter of variadic macro
                        "-Wformat"
                        "-Wformat-nonliteral"
                        "-Wtautological-compare"
                        "-Wunreachable-code"

                        "-Werror"
#                       "-Winline"                          # gcc on Linux seems to decide frequently not to inline, and warns about it.
#                                                           # We don't need to know about it, since not inlining is not a problem.
                        "-Wshadow"
                        "-Wsign-conversion"
#                       "-Wuseless-cast"                    # not supported by Clang
#                       "-Wzero-as-null-pointer-constant"   # not supported by Clang
    )

    if (NOT DEFINED ALLOW_EXCEPTIONS)
        option(ALLOW_EXCEPTIONS "Allow exceptions" OFF)
    endif()
    if (NOT ${ALLOW_EXCEPTIONS})
        set(COMPILER_FLAGS "${COMPILER_FLAGS}" "-fno-exceptions")
    endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    # Remove /W3 since /W4 will be added (otherwise we get a warning about replacing /W3 with /W4)
    string(REPLACE "/W3" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

    # Remove /EHsc since /EHsc- will be added (otherwise we get a warning about replacing /EHsc with /EHsc-)
    string(REPLACE "/EHsc" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

    # Remove /GR since /GR- will be added (otherwise we get a warning about replacing /GR with /GR-)
    string(REPLACE "/GR" "" CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS})

    set(COMPILER_FLAGS
                        "/W4"
                        "/WX"       # treat all warnings as errors
#                       "/wdxxxx"   # suppress specific warnings
#                       "/wd4820"   # suppress warning about padding
                        "/wd4625"   # suppress warning:
                                    # copy constructor could not be generated because a base class
                                    # copy constructor is inaccessible or deleted
                        "/wd4626"   # assignment operator could not be generated because a base
                                    # class assignment operator is inaccessible or deleted
                        "/wd4127"   # suppress warning: conditional expression is constant
                        "/wd4505"   # suppress warning: unreferenced function has been removed
                        "/wd4206"   # suppress warning: translation unit is empty
                        "/wd4515"   # suppress warning: namespace uses itself
#                        "/wd4512"   # suppress warning: assignment operator could not be generated
                                    # A fix is planned in Qt 5.4.2 (https://bugreports.qt.io/browse/QTBUG-7233)
                                    # Check later with Qt >= 5.4.2 if warning suppression can be removed
                        "/wd4714"   # suppress warning: marked __forceinline but are not inlined
                                    # Fixed in Qt 5.10.0 (https://bugreports.qt.io/browse/QTBUG-55042)
                                    # Check later with Qt >= 5.10.0 if warning suppression can be removed
                        "/wd4718"   # Workaround for https://bugreports.qt.io/browse/QTBUG-54089
                        "/nologo"
                        "/EHsc-"    # disable exceptions
                        "/GR-"      # disable RTTI
    )
endif()

string(REPLACE ";" " " COMPILER_FLAGS_STRING "${COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMPILER_FLAGS_STRING}")

# disable compiler optimization which can cause release version to crash when using MinGW
if(WIN32 AND NOT UNIX AND CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-ipa-cp-clone")
endif()

# Enable Position Indepent Code (PIC) for all builds.
if (NOT WIN32)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
endif (NOT WIN32)
