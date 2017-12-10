INCLUDE_DIRECTORIES(BEFORE ${CMAKE_BINARY_DIR}/include)

#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
#    message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()

function(JOIN VALUES GLUE OUTPUT)
    string (REPLACE ";" "${GLUE}" _TMP_STR "${VALUES}")
    set (${OUTPUT} "${_TMP_STR}" PARENT_SCOPE)
endfunction()

function(ext_ffmpeg SUFFIX INC LD ARGS)
    set(FFMPEG_ROOT ${CMAKE_BINARY_DIR}/ffmpeg${SUFFIX})
    set(FFMPEG${SUFFIX}_INCLUDE_DIRS ${FFMPEG_ROOT}/include PARENT_SCOPE)
    set(FFMPEG${SUFFIX}_LIBRARY_DIRS ${FFMPEG_ROOT}/lib PARENT_SCOPE)

    if(WIN32)
        list(APPEND ARGS "--enable-w32threads;--disable-pthreads")
    endif()

    if(INC)
        list(REMOVE_DUPLICATES INC)
        string(REPLACE ";" " -I" INC_FLAT "${INC}")
        set(CFLAGS "--extra-cflags=\"-I${INC_FLAT}\"")
    endif()

    if(LD)
        list(REMOVE_DUPLICATES LD)
        string(REPLACE ";" " -L" LD_FLAT "${LD}")
        set(LDFLAGS "--extra-ldflags=\"-L${LD_FLAT}\"")
    endif()

    if(ARGS)
        list(REMOVE_DUPLICATES ARGS)
        string(REPLACE ";" " " ARGS_FLAT "${ARGS}")
        set(ARGS " ${ARGS_FLAT}")
    endif()

    string(REPLACE "\\" "/" PKG_CONFIG_PATH "$ENV{PKG_CONFIG_PATH}")
    #file(MAKE_DIRECTORY ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX})
    file(WRITE ${FFMPEG_ROOT}/src/config${SUFFIX}.sh
            "#!/bin/sh
export PKG_CONFIG_PATH=\"${PKG_CONFIG_PATH};${LIBOPENH264_LIBRARY_DIRS}/pkgconfig\"
${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/configure --prefix=${FFMPEG_ROOT} --enable-version3 --disable-programs --disable-doc --disable-network --disable-everything --disable-iconv --enable-decoder=mjpeg --enable-parser=mjpeg --enable-filter=format --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink ${CFLAGS} ${LDFLAGS} ${ARGS}
"
    )
    if(WIN32)
        file(APPEND ${FFMPEG_ROOT}/src/config${SUFFIX}.sh "
sed -i -e 's/#define HAVE_CLOCK_GETTIME.*/#define HAVE_CLOCK_GETTIME 0/' ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}-build/config.h
sed -i -e 's/#define HAVE_NANOSLEEP.*/#define HAVE_NANOSLEEP 0/' ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}-build/config.h
"
        )
    endif()
    ExternalProject_Add(ffmpeg${SUFFIX}
            # setup
            PREFIX ${FFMPEG_ROOT}
            LOG_CONFIGURE 1

            # download
            DOWNLOAD_DIR ${external_download_dir}
            URL https://www.ffmpeg.org/releases/ffmpeg-3.4.tar.gz
            URL_HASH SHA256=6ED03B00404A3923E3C2F560248A9C9AD79FBAAEE26D723F74AAE6B31FE2BAE6
            TLS_VERIFY true

            UPDATE_COMMAND cp ${FFMPEG_ROOT}/src/config${SUFFIX}.sh ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/config.sh

            # configure
            #CONFIGURE_COMMAND echo asdf
            CONFIGURE_COMMAND sh ${FFMPEG_ROOT}/src/ffmpeg${SUFFIX}/config.sh

            # build
            #BUILD_COMMAND echo asdf
            BUILD_COMMAND make

            # install
            INSTALL_COMMAND make install
    )
endfunction()

# build two variants of FFmpeg: with and without h264 enabled
list(APPEND extra_includes ${libmp3lame_INCLUDE_DIRS})
list(APPEND extra_libs ${libmp3lame_LIBRARY_DIRS})
list(APPEND extra_args "--enable-libmp3lame;--enable-encoder=libmp3lame")
ext_ffmpeg("" "${extra_includes}" "${extra_libs}" "${extra_args}")

list(APPEND extra_includes ${LIBOPENH264_INCLUDE_DIRS})
list(APPEND extra_libs ${LIBOPENH264_LIBRARY_DIRS})
list(APPEND extra_args "--enable-parser=h264;--enable-libopenh264;--enable-encoder=libopenh264;--enable-decoder=libopenh264")
ext_ffmpeg("_OH264" "${extra_includes}" "${extra_libs}" "${extra_args}")
