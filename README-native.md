Build jnffmpeg
==============

Versions
--------
- FFmpeg 3.4
- lame 3.99.5/lame-3.100
- openh264 1.7.0.

Prerequisites
-------------

### Windows
- Get [MSYS2 64bit distro](http://www.msys2.org/)
- Update it according to [instructions](https://github.com/msys2/msys2/wiki/MSYS2-installation)
- Install packages (pacman -S):
  - make
  - diffutils
  - yasm
  - mingw-w64-i686-gcc
  - mingw-w64-x86_64-gcc
  - pkg-config
  - git
  - nasm

Copy `<msys2-installir>/mingw64/bin/x86_64-w64-mingw32-gcc-ar.exe` to
`<msys2-installir>/mingw64/bin/x86_64-w64-mingw32-ar.exe`

### OS X
- [nasm](http://www.nasm.us/pub/nasm/releasebuilds/2.13/macosx/nasm-2.13-macosx.zip)
- `brew install pkg-config`


Libraries
---------
### lame

```
./configure \
    --disable-shared --enable-static \
    --enable-nasm \
    --disable-analyzer-hooks --disable-decoder --disable-frontend \
    --with-pic -msse

make
```

FFmpeg looks for `lame.h` as `lame/lame.h` but the installed lame-3.99.5 does not
have the lame directory so go into lame-3.99.5/include and `ln -s . lame` on
Linux and Mac OS X or `mklink /d lame .` on Windows.
(instructions above not needed for lame-3.100)

For x86, `export CFLAGS=-msse` to enable the SSE intrinsics. See Lame#443 for
details: https://sourceforge.net/p/lame/bugs/443/

### openh264

#### Windows
x86:
`make ARCH=i686 PREFIX=/mingw32 install`

x64:
`make ARCH=x86_64 PREFIX=/mingw64 install`

#### Mac OS X
```
make install
cd openh264-1.7.0/codec/api
export PKG_CONFIG_PATH=$OH264
```

### ffmpeg
We need two different ffmpeg builds, one with and one without libopenh264

Set paths for the previously compiled lame and openh264:
```
export MP3LAME_HOME=/c/Java/lame-3.99.5
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
 --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink \
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
 --enable-filter=hflip --enable-filter=scale --enable-filter=nullsink \
 --extra-cflags="-I$MP3LAME_HOME/include" \
 --extra-ldflags="-L$MP3LAME_HOME/libmp3lame -L$MP3LAME_HOME/libmp3lame/.libs"

make
```

#### Windows
Make sure that pthreads are not used. It might be necessary to append
`--enable-w32threads --disable-pthreads`. The configure script might also
detect `nanosleep` and `clock_gettime`, manually disable those in `config.h`
by setting `HAVE_CLOCK_GETTIME` and `HAVE_NANOSLEEP` to `0`.

#### Linux
Add the following to the configure line:
`--enable-pic`


### jnffmpeg
```
export FFMPEG_HOME=/Users/dminkov/dev/ffmpeg/ffmpeg-3.4
export FFMPEG_HOME_NO_OPENH264=/Users/dminkov/dev/ffmpeg/ffmpeg-3.4-no-openh264
export MP3LAME_HOME=/Users/dminkov/dev/ffmpeg/lame-3.99.5
export OH264=/Users/dminkov/dev/ffmpeg/openh264-1.7.0

ant ffmpeg -Dffmpeg=$FFMPEG_HOME -Dlame=$MP3LAME_HOME -Dopenh264=$OH264
# -Darch=32
ant ffmpeg -Dffmpeg=$FFMPEG_HOME_NO_OPENH264 -Dlame=$MP3LAME_HOME -DskipOpenh264=true 
# -Darch=32
```

Define the environment variable JAVA_HOME so that the JNI headers can be found.
Change the current directory to libjitsi/ and run "ant ffmpeg" passing it values
for the ffmpeg, lame, and open264 properties which specify the paths to
the homes of the development trees of the respective libraries.
