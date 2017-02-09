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

# Usage

You can include these files in your CMakeLists.txt
```
# Include common cmake modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/path/to/cmake/common)
include(CommonConfig)
```
