# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(dart_md4c_library VERSION 0.0.1 LANGUAGES C)

add_library(dart_md4c SHARED
  "dart_md4c.c"
)

set_target_properties(dart_md4c PROPERTIES
  PUBLIC_HEADER dart_md4c.h
  OUTPUT_NAME "dart_md4c"
)

target_compile_definitions(dart_md4c PUBLIC DART_SHARED_LIB)
