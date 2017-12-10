set(OPENH264_ROOT ${CMAKE_BINARY_DIR}/openh264)
set(LIBOPENH264_INCLUDE_DIRS ${OPENH264_ROOT}/include)
set(LIBOPENH264_LIBRARY_DIRS ${OPENH264_ROOT}/lib)

ExternalProject_Add(openh264
        # setup
        PREFIX ${OPENH264_ROOT}

        # download
        DOWNLOAD_DIR ${external_download_dir}
        GIT_REPOSITORY https://github.com/cisco/openh264
        GIT_TAG a180c9d4d6f1a4830ca9eed9d159d54996bd63cb #v1.7.0
        #URL https://www.ffmpeg.org/releases/ffmpeg-3.4.tar.gz
        #URL_HASH SHA256=6ED03B00404A3923E3C2F560248A9C9AD79FBAAEE26D723F74AAE6B31FE2BAE6
        TLS_VERIFY true

        CONFIGURE_COMMAND ""
        BUILD_COMMAND make -f ${OPENH264_ROOT}/src/openh264/Makefile ARCH=x86_64 PREFIX=${OPENH264_ROOT}

        # install
        INSTALL_COMMAND make -f ${OPENH264_ROOT}/src/openh264/Makefile PREFIX=${OPENH264_ROOT} install
)
