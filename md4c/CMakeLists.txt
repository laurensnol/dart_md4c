
# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(dart_md4c_library VERSION 0.0.1 LANGUAGES C)

set(MD_VERSION_MAJOR 0)
set(MD_VERSION_MINOR 4)
set(MD_VERSION_RELEASE 8)
set(MD_VERSION "${MD_VERSION_MAJOR}.${MD_VERSION_MINOR}.${MD_VERSION_RELEASE}")

set(PROJECT_VERSION "${MD_VERSION}")
set(PROJECT_URL "https://github.com/mity/md4c")

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS 1)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DDEBUG")

if(WIN32)
    # On Windows, given there is no standard lib install dir etc., we rather
    # by default build static lib.
    
    # Note: Disabled for now, since it appears that Flutter requires shared libs.
    # option(BUILD_SHARED_LIBS "help string describing option" OFF)
else()
    # On Linux, MD4C is slowly being adding into some distros which prefer
    # shared lib.
    option(BUILD_SHARED_LIBS "help string describing option" ON)
endif()

add_definitions(
    -DMD_VERSION_MAJOR=${MD_VERSION_MAJOR}
    -DMD_VERSION_MINOR=${MD_VERSION_MINOR}
    -DMD_VERSION_RELEASE=${MD_VERSION_RELEASE}
)

set(CMAKE_CONFIGURATION_TYPES Debug Release RelWithDebInfo MinSizeRel)
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE $ENV{CMAKE_BUILD_TYPE})

    if("${CMAKE_BUILD_TYPE}" STREQUAL "")
        set(CMAKE_BUILD_TYPE "Release")
    endif()
endif()

if(${CMAKE_C_COMPILER_ID} MATCHES GNU|Clang)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")
elseif(MSVC)
    # Disable warnings about the so-called unsecured functions:
    add_definitions(/D_CRT_SECURE_NO_WARNINGS /W3)

    # Specify proper C runtime library:
    string(REGEX REPLACE "/M[DT]d?" "" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
    string(REGEX REPLACE "/M[DT]d?" "" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
    string(REGEX REPLACE "/M[DT]d?" "" CMAKE_C_FLAGS_RELWITHDEBINFO "{$CMAKE_C_FLAGS_RELWITHDEBINFO}")
    string(REGEX REPLACE "/M[DT]d?" "" CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL}")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELEASE} /MT")
    set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_RELEASE} /MT")
endif()

include(GNUInstallDirs)

# Build rules for MD4C parser library

configure_file(md4c.pc.in md4c.pc @ONLY)
add_library(md4c md4c.c md4c.h)
if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
    target_compile_options(md4c PRIVATE -Wall -Wextra)
endif()
set_target_properties(md4c PROPERTIES
    COMPILE_FLAGS "-DMD4C_USE_UTF8"
    VERSION ${MD_VERSION}
    SOVERSION ${MD_VERSION_MAJOR}
    PUBLIC_HEADER md4c.h
)

# Build rules for HTML renderer library

configure_file(md4c-html.pc.in md4c-html.pc @ONLY)
add_library(md4c-html md4c-html.c md4c-html.h entity.c entity.h)
set_target_properties(md4c-html PROPERTIES
    VERSION ${MD_VERSION}
    SOVERSION ${MD_VERSION_MAJOR}
    PUBLIC_HEADER md4c-html.h
)
target_link_libraries(md4c-html md4c)

# add_subdirectory(src)

# target_compile_definitions(dart_md4c PUBLIC DART_SHARED_LIB)
