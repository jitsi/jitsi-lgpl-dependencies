set(LAME_ROOT ${CMAKE_BINARY_DIR}/lame)
set(libmp3lame_INCLUDE_DIRS ${LAME_ROOT}/include)
set(libmp3lame_LIBRARY_DIRS ${LAME_ROOT}/lib)

if (APPLE)
    if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        set(LAME_HOST "--host=aarch64-apple-darwin")
    endif ()
    set(LAME_CFLAGS "CFLAGS=-arch ${CMAKE_OSX_ARCHITECTURES}")
endif ()

externalproject_add(lame
                    # setup
                    PREFIX ${LAME_ROOT}

                    # download
                    DOWNLOAD_DIR ${external_download_dir}
                    URL https://downloads.sourceforge.net/lame/lame-3.100.tar.gz
                    URL_HASH SHA256=DDFE36CAB873794038AE2C1210557AD34857A4B6BDC515785D1DA9E175B1DA1E
                    TLS_VERIFY true

                    # configure
                    CONFIGURE_COMMAND sh ${LAME_ROOT}/src/lame/configure ${LAME_CFLAGS} ${LAME_HOST} --prefix=${LAME_ROOT} --disable-shared --disable-debug --enable-static --enable-nasm --disable-analyzer-hooks --disable-decoder --disable-frontend --with-pic

                    # build
                    BUILD_COMMAND make

                    # install
                    INSTALL_COMMAND make install
                    )
