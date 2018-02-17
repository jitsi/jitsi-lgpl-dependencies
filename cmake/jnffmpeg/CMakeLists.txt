project(jnffmpeg)

# JNI
find_package(JNI REQUIRED)

include_directories(
        ${JNI_INCLUDE_DIRS}
        ${FFMPEG_INCLUDE_DIRS}
)

link_directories(
        ${libmp3lame_LIBRARY_DIRS}
        ${FFMPEG_LIBRARY_DIRS}
)

add_library(${PROJECT_NAME} SHARED ../../src/main/c/ffmpeg/FFmpeg.c)

target_link_libraries(${PROJECT_NAME}
        avformat
        avcodec
        avfilter
        avutil
        swscale
        mp3lame
)

if(UNIX)
    macro(patchelf SOURCE TARGET)
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND "patchelf"
                ARGS --replace-needed ${SOURCE} ${TARGET} $<TARGET_FILE:${PROJECT_NAME}>
                COMMENT "Running patchelf for ${SOURCE}"
                )
    endmacro()

    patchelf(libavformat-ffmpeg.so.56 libavformat.so)
    patchelf(libavcodec-ffmpeg.so.56 libavcodec.so)
    patchelf(libavfilter-ffmpeg.so.5 libavfilter.so)
    patchelf(libavutil-ffmpeg.so.54 libavutil.so)
    patchelf(libswscale-ffmpeg.so.3 libswscale.so)
endif()

if(NOT APPLE)
    if(${CMAKE_SIZEOF_VOID_P} EQUAL 8)
        set(arch -x86-64)
    else()
        set(arch -x86)
    endif()
endif()

if(WIN32)
    target_link_libraries(${PROJECT_NAME}
            -static-libgcc
            -static-libstdc++
            -Wl,--kill-at)
    set_target_properties(${PROJECT_NAME} PROPERTIES
            OUTPUT_NAME "jnffmpeg-no-openh264"
            PREFIX "")
    set(os win32)
elseif(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES
            OUTPUT_NAME "jnffmpeg-no-openh264")
    set(os darwin)
else()
    set(os linux)
endif()

message(STATUS "Installation destination: " ${CMAKE_SOURCE_DIR}/src/main/resources/${os}${arch})

install(TARGETS ${PROJECT_NAME}
        RUNTIME DESTINATION ${CMAKE_SOURCE_DIR}/src/main/resources/${os}${arch}
        LIBRARY DESTINATION ${CMAKE_SOURCE_DIR}/src/main/resources/${os}${arch})