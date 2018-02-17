set(LAME_ROOT ${CMAKE_BINARY_DIR}/lame)
set(libmp3lame_INCLUDE_DIRS ${LAME_ROOT}/include)
set(libmp3lame_LIBRARY_DIRS ${LAME_ROOT}/lib)

ExternalProject_Add(lame
        # setup
        PREFIX ${LAME_ROOT}

        # download
        DOWNLOAD_DIR ${external_download_dir}
        #URL https://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz
        #URL_HASH SHA256=24346b4158e4af3bd9f2e194bb23eb473c75fb7377011523353196b19b9a23ff
        URL https://downloads.sourceforge.net/lame/lame-3.100.tar.gz
        URL_HASH SHA256=DDFE36CAB873794038AE2C1210557AD34857A4B6BDC515785D1DA9E175B1DA1E
        TLS_VERIFY true

        # configure
        CONFIGURE_COMMAND sh ${LAME_ROOT}/src/lame/configure --prefix=${LAME_ROOT} --disable-shared --enable-static --enable-nasm --disable-analyzer-hooks --disable-decoder --disable-frontend --with-pic

        # build
        BUILD_COMMAND make

        # install
        INSTALL_COMMAND make install
)
