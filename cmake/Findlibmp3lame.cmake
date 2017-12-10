# - Try to find lame
# Once done, this will define
#
#  libmp3lame_FOUND - system has libmp3lame
#  libmp3lame_INCLUDE_DIRS - the libmp3lame include directories
#  libmp3lame_LIBRARIES - link these to use libmp3lame

include(LibFindMacros)

# Use pkg-config to get hints about paths
libfind_pkg_check_modules(libmp3lame_PKGCONF libmp3lame)

# Include dir
find_path(libmp3lame_INCLUDE_DIR
        NAMES lame/lame.h
        PATHS ${libmp3lame_PKGCONF_INCLUDE_DIRS}
        )

# Finally the library itself
find_library(libmp3lame_LIBRARY
        NAMES libmp3lame
        PATHS ${libmp3lame_PKGCONF_LIBRARY_DIRS}
        )

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
libfind_process(libmp3lame)
get_filename_component(libmp3lame_LIBRARY_DIRS ${libmp3lame_LIBRARIES} DIRECTORY)
