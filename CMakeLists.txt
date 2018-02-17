cmake_minimum_required (VERSION 3.5)
project(jitsi-lgpl-dependencies)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
find_package(PkgConfig REQUIRED)

add_subdirectory(thirdparty)
add_subdirectory(cmake/jnffmpeg)
if(WIN32 OR APPLE)
    add_subdirectory(cmake/jnffmpeg_oh264)
endif()
