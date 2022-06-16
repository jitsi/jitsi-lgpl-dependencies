project(jng722)

# JNI
find_package(JNI REQUIRED)

include_directories(
        ../../../../target/native/javah
        ${JNI_INCLUDE_DIRS}
)

add_library(${PROJECT_NAME} SHARED
            g722.c
            JNIDecoder.c
            JNIEncoder.c
            vector_int.c
            )

if (WIN32)
    target_link_libraries(${PROJECT_NAME}
                          -static-libgcc
                          -static-libstdc++
                          -Wl,--kill-at)
endif ()

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if (WIN32 AND CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/win32-x86-64" CACHE PATH "default install path" FORCE)
    elseif (WIN32)
        set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/win32-x86" CACHE PATH "default install path" FORCE)
    elseif (APPLE)
        if (CMAKE_OSX_ARCHITECTURES STREQUAL "x86_64")
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/darwin-x86-64" CACHE PATH "default install path" FORCE)
        else ()
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/darwin-aarch64" CACHE PATH "default install path" FORCE)
        endif ()
    elseif (UNIX)
        if (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" AND CMAKE_SIZEOF_VOID_P EQUAL 4)
            set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/../../src/main/resources/linux-x86" CACHE PATH "default install path" FORCE)
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
