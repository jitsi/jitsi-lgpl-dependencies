include_directories(BEFORE ${CMAKE_BINARY_DIR}/include)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()

function(join VALUES GLUE OUTPUT)
    string(REPLACE ";" "${GLUE}" _TMP_STR "${VALUES}")
    set(${OUTPUT} "${_TMP_STR}" PARENT_SCOPE)
endfunction()

function(ext_ffmpeg SUFFIX EXTRA_CFLAGS EXTRA_LDFLAGS ARGS)
    set(FFMPEG_ROOT ${CMAKE_BINARY_DIR}/ffmpeg${SUFFIX})
    set(FFMPEG${SUFFIX}_INCLUDE_DIRS ${FFMPEG_ROOT}/include PARENT_SCOPE)
    set(FFMPEG${SUFFIX}_LIBRARY_DIRS ${FFMPEG_ROOT}/lib PARENT_SCOPE)

    if (WIN32)
        list(APPEND ARGS "--enable-w32threads;--disable-pthreads")
    endif ()
    if (APPLE)
        if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
            list(APPEND ARGS "--arch=arm64;--enable-cross-compile")
            list(APPEND EXTRA_CFLAGS "--target=arm64-apple-darwin")
            list(APPEND EXTRA_LDFLAGS "--target=arm64-apple-darwin")
        endif ()
    endif ()

    if (EXTRA_CFLAGS)
        list(REMOVE_DUPLICATES EXTRA_CFLAGS)
        string(REPLACE ";" " " CFLAGS_FLAT "${EXTRA_CFLAGS}")
        set(CFLAGS "--extra-cflags=\"${CFLAGS_FLAT}\"")
    endif ()

    if (EXTRA_LDFLAGS)
        list(REMOVE_DUPLICATES EXTRA_LDFLAGS)
        string(REPLACE ";" " " LDFLAGS_FLAT "${EXTRA_LDFLAGS}")
        set(LDFLAGS "--extra-ldflags=\"${LDFLAGS_FLAT}\"")
    endif ()

    if (ARGS)
        list(REMOVE_DUPLICATES ARGS)
        string(REPLACE ";" " " ARGS_FLAT "${ARGS}")
        set(ARGS " ${ARGS_FLAT}")
    endif ()

    string(REPLACE "\\" "/" PKG_CONFIG_PATH "$ENV{PKG_CONFIG_PATH}")
    #file(MAKE_DIRECTORY ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX})
    file(WRITE ${FFMPEG_ROOT}/src/config${SUFFIX}.sh
         "#!/bin/sh
export PKG_CONFIG_PATH=\"${LIBOPENH264_LIBRARY_DIRS}/pkgconfig\"
${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/configure --prefix=${FFMPEG_ROOT} --enable-version3 --disable-programs --disable-doc --disable-network --disable-everything --disable-iconv --enable-decoder=mjpeg --enable-parser=mjpeg --enable-filter=format --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink ${CFLAGS} ${LDFLAGS} ${ARGS}
"
         )
    if (WIN32)
        file(APPEND ${FFMPEG_ROOT}/src/config${SUFFIX}.sh "
sed -i -e 's/#define HAVE_CLOCK_GETTIME.*/#define HAVE_CLOCK_GETTIME 0/' ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}-build/config.h
sed -i -e 's/#define HAVE_NANOSLEEP.*/#define HAVE_NANOSLEEP 0/' ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}-build/config.h
"
             )
    endif ()
    externalproject_add(ffmpeg${SUFFIX}
                        # setup
                        PREFIX ${FFMPEG_ROOT}
                        LOG_CONFIGURE 1

                        # download
                        GIT_REPOSITORY https://github.com/FFmpeg/FFmpeg
                        GIT_TAG 7e0d640edf6c3eee1816b105c2f7498c4f948e74 #n4.4.1
                        TLS_VERIFY true

                        # this should be part of the configure command, but calling it with "sh -c" doesn't work on Mac
                        # and I don't have enough patience to figure it out
                        UPDATE_COMMAND cp ${FFMPEG_ROOT}/src/config${SUFFIX}.sh ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/config.sh

                        # configure
                        CONFIGURE_COMMAND sh ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/config.sh

                        # build
                        BUILD_COMMAND make

                        # install
                        INSTALL_COMMAND make install
                        )
endfunction()

# build two variants of FFmpeg: with and without h264 enabled
list(APPEND extra_cflags "-I${libmp3lame_INCLUDE_DIRS}")
list(APPEND extra_ldflags "-L${libmp3lame_LIBRARY_DIRS}")
list(APPEND extra_args "--enable-libmp3lame;--enable-encoder=libmp3lame")
ext_ffmpeg("" "${extra_cflags}" "${extra_ldflags}" "${extra_args}")

list(APPEND extra_cflags "-I${LIBOPENH264_INCLUDE_DIRS}")
list(APPEND extra_ldflags "-L${LIBOPENH264_LIBRARY_DIRS}")
list(APPEND extra_args "--enable-parser=h264;--enable-libopenh264;--enable-encoder=libopenh264;--enable-decoder=libopenh264")
ext_ffmpeg("_OH264" "${extra_cflags}" "${extra_ldflags}" "${extra_args}")
