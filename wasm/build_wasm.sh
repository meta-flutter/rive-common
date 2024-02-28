#!/bin/bash
set -e

CONFIG=debug
SINGLE=
THREADS=
for var in "$@"; do
    if [[ $var = "release" ]]; then
        CONFIG=release
    fi
    if [[ $var = "single" ]]; then
        SINGLE=--single_file
    fi
    if [[ $var = "threads" ]]; then
        THREADS=--use_threads
    fi
done

pushd ../
./update_dependencies.sh
popd

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=linux ;;
Darwin*) MACHINE=mac ;;
CYGWIN*) MACHINE=cygwin ;;
MINGW*) MACHINE=mingw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

if [[ ! -f "bin/premake5" ]]; then
    mkdir -p bin
    pushd bin
    echo Downloading Premake5
    if [ "$MACHINE" = 'mac' ]; then
        PREMAKE_URL=https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-macosx.tar.gz
    else
        PREMAKE_URL=https://github.com/premake/premake-core/releases/download/v5.0.0-beta2/premake-5.0.0-beta2-linux.tar.gz
    fi
    curl $PREMAKE_URL -L -o premake.tar.gz
    # Export premake5 into bin
    tar -xvf premake.tar.gz 2>/dev/null
    # Delete downloaded archive
    rm premake.tar.gz
    popd
fi

source ./get_emcc.sh

export PREMAKE=bin/premake5

pushd ../taffy_ffi
RUSTFLAGS="-Clinker-plugin-lto --emit=llvm-ir" $HOME/.cargo/bin/cargo build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target wasm32-unknown-emscripten --profile minimize
popd

$PREMAKE --scripts=../macos/rive-cpp/build --file=../premake5_rive_plugin.lua gmake2 $SINGLE $THREADS --arch=wasm

cd ..
for var in "$@"; do
    if [[ $var = "clean" ]]; then
        make clean
        make config=release clean
    fi
done

AR=emar CC=emcc CXX=em++ make config=$CONFIG -j$(($(sysctl -n hw.physicalcpu) + 1))

du -hs wasm/build/bin/$CONFIG/rive_text.wasm
