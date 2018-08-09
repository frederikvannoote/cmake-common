# Common cmake components

This repository contains very generic cmake components which can be used across other cmake projects.

# Including in your code.
The common cmake files need to be present when cmake is run.
There are various ways of achieving this.

## Git submodule
You can fetch the files during your git clone using a submodule.
```
git submodule add -b <tag> git@github.com:barco-healthcare/cmake-common.git path/to/cmake/common
```

## Cloning during cmake run
Add this snippet to your CMakeLists.txt
```
# Download build system
if(NOT EXISTS "${CMAKE_BINARY_DIR}/buildsys/v2.0")
    message(STATUS "Downloading buildsystem...")

    find_package(Git REQUIRED)
    execute_process(COMMAND ${GIT_EXECUTABLE} clone --branch v2.0 https://github.com/frederikvannoote/cmake-common.git ${CMAKE_BINARY_DIR}/buildsys/v2.0)
endif()
list(APPEND CMAKE_MODULE_PATH "${CMAKE_BINARY_DIR}/buildsys/v2.0")
```

# Usage

You can include these files in your CMakeLists.txt
```
# Include common cmake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/path/to/cmake/common)
include(CommonConfig)
```
