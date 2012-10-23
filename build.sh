#!/bin/bash

if [ ! -e x264 ]; then
    echo Fetching x264...
    git clone --depth 1 git://git.videolan.org/x264.git x264
else
    echo Updating x264...
    (cd x264 && git pull)
fi

if [ ! -e ffmpeg ]; then
    echo Fetching ffmpeg
    git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git ffmpeg
else
    echo Updating ffmpeg... 
    (cd ffmpeg && git pull)
fi

if [ "$ARCHS" = "" ]; then
    ARCHS="armv6 armv7a neon"
    echo ARCHS not defined. Using \"$ARCHS\"
fi

if [ "$ANDROID_NDK" = "" ]; then
    if [ -d /opt/android-ndk ]; then
        ANDROID_NDK=/opt/android-ndk
    elif [ -d $HOME/android-ndk ]; then
        ANDROID_NDK=$HOME/android-ndk
    else
        echo ANDROID_NDK not defined. Aborting.
        exit 1
    fi
fi

SYSROOT=$ANDROID_NDK/platforms/android-9/arch-arm
# Expand the prebuilt/* path into the correct one
TOOLCHAIN=`echo $ANDROID_NDK/toolchains/arm-linux-androideabi-4.4.3/prebuilt/*-x86`
export PATH=$TOOLCHAIN/bin:$PATH

echo Using toolchain $TOOLCHAIN

if [ ! -e build ]; then
    mkdir build
fi

CROSS_FLAGS="--sysroot=$SYSROOT --cross-prefix=arm-linux-androideabi-"
FFMPEG_FLAGS="$CROSS_FLAGS --target-os=linux --enable-libx264 --enable-gpl --arch=arm"

for arch in $ARCHS; do
    echo Building for $arch
    rm -fr build/"$arch"

    X264_DEST=build/$arch/x264
    FFMPEG_DEST=build/$arch/ffmpeg

    case $arch in
        armv7a)
            EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -fPIC -DANDROID"
            EXTRA_LDFLAGS=""
            ;;
        neon)
            EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -fPIC -DANDROID"
            EXTRA_CFLAGS="$EXTRA_CFLAGS -mfpu=neon"
            EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
            ;;
        armv6)
            EXTRA_CFLAGS="-march=armv6"
            EXTRA_LDFLAGS=""
            ;;
        *)
            echo Unknown platform $arch
            exit 1
            ;;
    esac

    set -xv

    (
        cd x264 && CFLAGS="$EXTRA_CFLAGS" LDFLAGS="$EXTRA_LDFLAGS" \
        ./configure $CROSS_FLAGS --host=arm-linux-androideabi --enable-shared \
        --prefix=../$X264_DEST --enable-static && make clean && make -j 4 && make install
    )

    EXTRA_CFLAGS="$EXTRA_CFLAGS -I../$X264_DEST/include"
    EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L../$X264_DEST/lib"

    (
        cd ffmpeg && \
        ./configure $FFMPEG_FLAGS --extra-cflags="$EXTRA_CFLAGS" \
        --extra-ldflags="$EXTRA_LDFLAGS" --prefix=../$FFMPEG_DEST && \
        make clean && make -j 4 && make install
    )

done

# vim: ts=4 sw=4 noexpandtab softtabstop=4