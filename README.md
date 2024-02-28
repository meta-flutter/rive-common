[![Pub Version](https://img.shields.io/pub/v/rive_common)](https://pub.dev/packages/rive_common)
![Discord badge](https://img.shields.io/discord/532365473602600965)
![Twitter handle](https://img.shields.io/twitter/follow/rive_app.svg?style=social&label=Follow)

# Rive Common

A common library for the Rive editor and runtime to share functionality. Not intended to be used directly by end-users.

## Building for Linux

*Clang is required*

    git clone https://github.com/meta-flutter/rive-common
    git submodule update init --recursive
    cd rive-common
    mkdir build
    cd build
    CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake ..
    make -j
    export LD_LIBRARY_PATH=`pwd`
    cd taffy_ffi
    cargo build --release
    cd target/release
    export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH

## Running rive-flutter on ivi-homescreen

    https://github.com/rive-app/rive-flutter.git
    cd rive-flutter
    git checkout 870234fddc8e6aae3d29ef1dd63fb8e55aba5802
    git apply 0001-Changes-for-generic-Linux.patch

After patch step adjust path in pubspec.yaml for rive_common to point to root of this repo

    flutter run -d desktop-homescreen
    q
    export BUNDLE=`pwd`/.desktop-homescreen
    homescreen --b=$BUNDLE --w=800 --h=720
