Manually building jnffmpeg
==========================

Library versions
----------------
- FFmpeg 3.4
- lame 3.100
- openh264 2.2.1

Prerequisites
-------------
All systems: Java 8 or newer, Maven, CMake >= 3.10

### Windows
- Get [MSYS2 64bit distro](http://www.msys2.org/)
- Update it according to [instructions](https://www.msys2.org/wiki/MSYS2-installation/)
- Install packages (pacman -S):
  - make
  - diffutils
  - yasm
  - git
  - pkg-config
  - nasm
  - mingw-w64-i686-toolchain
  - mingw-w64-i686-cmake
  - mingw-w64-i686-pkg-config
  - mingw-w64-x86_64-toolchain
  - mingw-w64-x86_64-cmake
  - mingw-w64-x86_64-pkg-config


### OS X
- `brew install nasm`
- `brew install pkg-config`


Build libraries
---------------
### lame

```
./configure \
    --disable-shared --enable-static \
    --enable-nasm \
    --disable-analyzer-hooks --disable-decoder --disable-frontend \
    --with-pic

make
```

For x86, `export CFLAGS=-msse` to enable the SSE intrinsics.
See [Lame#443](https://sourceforge.net/p/lame/bugs/443/) for details.

### openh264

#### Windows
x86:
`make ARCH=i686 PREFIX=/mingw32 install`

x64:
`make ARCH=x86_64 PREFIX=/mingw64 install`

#### Mac OS X
```
make install
cd openh264-2.2.1/codec/api
export PKG_CONFIG_PATH=$OH264
```

### ffmpeg
We need two different ffmpeg builds, one with and one without libopenh264

Set paths for the previously compiled lame and openh264
(adjust the paths accordingly):
```
export MP3LAME_HOME=/c/Java/lame-3.100
export OH264=/c/Java/openh264
```

1) With OpenH264
```
./configure \
 --enable-version3 \
 --disable-programs \
 --disable-doc \
 --disable-network \
 --disable-everything \
 --disable-iconv \
 --enable-libmp3lame --enable-encoder=libmp3lame \
 --enable-parser=h264 \
 --enable-libopenh264 --enable-encoder=libopenh264 --enable-decoder=libopenh264 \
 --enable-decoder=mjpeg --enable-parser=mjpeg \
 --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink --enable-filter=format \
 --extra-cflags="-I$MP3LAME_HOME/include -I$OH264/codec/api" \
 --extra-ldflags="-L$MP3LAME_HOME/libmp3lame -L$MP3LAME_HOME/libmp3lame/.libs -L$OH264"

make
```

2) Without OpenH264
```
./configure \
 --enable-version3 \
 --disable-programs \
 --disable-doc \
 --disable-network \
 --disable-everything \
 --disable-iconv \
 --enable-libmp3lame --enable-encoder=libmp3lame \
 --enable-decoder=mjpeg --enable-parser=mjpeg \
 --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink --enable-filter=format \
 --extra-cflags="-I$MP3LAME_HOME/include" \
 --extra-ldflags="-L$MP3LAME_HOME/libmp3lame -L$MP3LAME_HOME/libmp3lame/.libs"

make
```

#### Windows
Make sure pthreads are not used. It might be necessary to append
`--enable-w32threads --disable-pthreads`. The configure script might also
detect `nanosleep` and `clock_gettime`, manually disable those in `config.h`
by setting `HAVE_CLOCK_GETTIME` and `HAVE_NANOSLEEP` to `0`.

#### Linux
Add the following to the configure line:
`--enable-pic`


### jnffmpeg
jnffmpeg uses CMake as the buildsystem, which includes building all necessary
libraries.
- Define the environment variable JAVA_HOME so that the JNI headers can be found.
- Compile the Java JNI headers with `mvn compile`
