project(jnffmpeg_oh264)

# JNI
find_package(JNI REQUIRED)

include_directories(
        ../../target/native/javah
        ${JNI_INCLUDE_DIRS}
        ${FFMPEG_INCLUDE_DIRS}
)

link_directories(
        ${libmp3lame_LIBRARY_DIRS}
        ${LIBOPENH264_LIBRARY_DIRS}
        ${FFMPEG_OH264_LIBRARY_DIRS}
)

add_library(${PROJECT_NAME} SHARED ../../src/main/c/ffmpeg/FFmpeg.c)

if (NOT USE_SYSTEM_FFMPEG)
    add_dependencies(${PROJECT_NAME} ffmpeg_OH264)
endif ()

if (APPLE)
    set(OS_LIBS -lopenh264 "-framework CoreVideo")
elseif (WIN32)
    set(OS_LIBS bcrypt openh264.dll)
endif ()

target_link_libraries(${PROJECT_NAME}
                      avformat
                      avcodec
                      avfilter
                      avutil
                      swscale
                      mp3lame
                      ${OS_LIBS}
                      )

if (WIN32)
    target_link_libraries(${PROJECT_NAME}
                          -static-libgcc
                          -static-libstdc++
                          -Wl,--kill-at)
    set_target_properties(${PROJECT_NAME} PROPERTIES
                          OUTPUT_NAME "jnffmpeg"
                          PREFIX "")
elseif (APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES
                          OUTPUT_NAME "jnffmpeg")
endif ()

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if (WIN32 AND CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/win32-x86-64" CACHE PATH "default install path" FORCE)
    elseif (WIN32)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/win32-x86" CACHE PATH "default install path" FORCE)
    elseif (APPLE)
        if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/mac-arm64" CACHE PATH "default install path" FORCE)
        else ()
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/mac-x86_64" CACHE PATH "default install path" FORCE)
        endif ()
    elseif (UNIX)
        if (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" AND CMAKE_SIZEOF_VOID_P EQUAL 4)
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/linux-x86" CACHE PATH "default install path" FORCE)
        elseif (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/linux-x86-64" CACHE PATH "default install path" FORCE)
        else ()
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/linux-${CMAKE_SYSTEM_PROCESSOR}" CACHE PATH "default install path" FORCE)
        endif ()
    endif ()
    message(STATUS "CMAKE_INSTALL_PREFIX not set, defaulting to >${CMAKE_INSTALL_PREFIX}<")
endif ()

message(STATUS "Installation destination: " ${CMAKE_INSTALL_PREFIX})

if (JITSI_BUILD_DEBIAN)
    install(TARGETS ${PROJECT_NAME}
            LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
else ()
    install(TARGETS ${PROJECT_NAME}
            RUNTIME DESTINATION "."
            LIBRARY DESTINATION ".")
endif ()
