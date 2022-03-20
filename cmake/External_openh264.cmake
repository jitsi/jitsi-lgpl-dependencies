set(OPENH264_ROOT ${CMAKE_BINARY_DIR}/openh264)
set(LIBOPENH264_INCLUDE_DIRS ${OPENH264_ROOT}/include)
set(LIBOPENH264_LIBRARY_DIRS ${OPENH264_ROOT}/lib)


if (APPLE)
    set(GNU_SED_INLINE "\"\"")
    if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        set(ARCH "arm64")
    endif ()
else ()
    if (${CMAKE_SIZEOF_VOID_P} EQUAL 8)
        set(ARCH x86_64)
    else ()
        set(ARCH x86)
    endif ()
    set(GNU_SED_INLINE "")
endif ()

externalproject_add(
        openh264
        # setup
        PREFIX ${OPENH264_ROOT}

        # download
        GIT_REPOSITORY https://github.com/cisco/openh264
        GIT_TAG 33c6546396a577afc49ae3a52a59c1d1b5c5ab71 #v2.2.0
        TLS_VERIFY true

        PATCH_COMMAND sed -i ${GNU_SED_INLINE} "s/^AR = x86_64-w64-mingw32-ar/AR = x86_64-w64-mingw32-gcc-ar/" ${OPENH264_ROOT}/src/openh264/build/platform-mingw_nt.mk
        CONFIGURE_COMMAND ""
        BUILD_COMMAND make -f ${OPENH264_ROOT}/src/openh264/Makefile ARCH=${ARCH} PREFIX=${OPENH264_ROOT}

        # install
        INSTALL_COMMAND make -f ${OPENH264_ROOT}/src/openh264/Makefile PREFIX=${OPENH264_ROOT} install
)
