set -e

if [ -d "./lib" ]
then
    echo "Existing libs deleted"
    rm -rf lib/*
else
    echo "Generating output directory"
    mkdir lib
fi

if [ -e "./src/Makefile.global" ]
then
    make -C ./src/interfaces/libpq distclean
fi

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneSimulator7.1.sdk

./configure --without-readline \
  CC="/usr/bin/gcc" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -miphoneos-version-min=7.0 -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  CPP="/usr/bin/cpp $CPPFLAGS"
make -C src/interfaces/libpq
cp src/interfaces/libpq/libpq.a lib/libpq_i386.a

make -C ./src/interfaces/libpq distclean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk

./configure --host=arm-apple-darwin --without-readline \
  CC="/usr/bin/gcc" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -arch armv7 -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  CPP="/usr/bin/cpp -D__arm__=1 $CPPFLAGS" \
  LD=$DEVROOT/usr/bin/ld
make -C src/interfaces/libpq
cp src/interfaces/libpq/libpq.a lib/libpq_armv7.a

make -C ./src/interfaces/libpq distclean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk

./configure --host=arm-apple-darwin --without-readline \
  CC="/usr/bin/gcc" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -arch armv7s -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  CPP="/usr/bin/cpp -D__arm__=1 $CPPFLAGS" \
  LD=$DEVROOT/usr/bin/ld
make -C src/interfaces/libpq
cp src/interfaces/libpq/libpq.a lib/libpq_armv7s.a

make -C ./src/interfaces/libpq distclean

DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
SDKROOT=$DEVROOT/SDKs/iPhoneOS7.1.sdk

./configure --host=arm-apple-darwin --without-readline \
  CC="/usr/bin/gcc" \
  CPPFLAGS="-I$SDKROOT/usr/include/" \
  CFLAGS="$CPPFLAGS -arch arm64 -pipe -no-cpp-precomp -isysroot $SDKROOT" \
  CPP="/usr/bin/cpp -D__arm64__=1 $CPPFLAGS" \
  LD=$DEVROOT/usr/bin/ld
make -C src/interfaces/libpq
cp src/interfaces/libpq/libpq.a lib/libpq_arm64.a

lipo -create lib/libpq_i386.a lib/libpq_armv7.a lib/libpq_armv7s.a lib/libpq_arm64.a -output lib/libpq.a
