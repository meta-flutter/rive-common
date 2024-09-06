#!/bin/bash
set -e

CONFIG=debug
SINGLE=
THREADS=
SIMD=
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
    if [[ $var = "simd" ]]; then
        SIMD=--use_simd
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

$PREMAKE --scripts=../macos/rive-cpp/build --file=../premake5_rive_plugin.lua gmake2 $SINGLE $THREADS $SIMD --arch=wasm

cd ..
for var in "$@"; do
    if [[ $var = "clean" ]]; then
        make clean
        make config=release clean
    fi
done

AR=emar CC=emcc CXX=em++ make config=$CONFIG -j$(($(sysctl -n hw.physicalcpu) + 1))

if [[ ! -z $THREADS ]]; then
    du -hs wasm/build/bin/$CONFIG/threads/rive_text.wasm
    cp wasm/build/bin/$CONFIG/threads/rive_text.wasm ../editor/web/rive_text.wasm
    cp wasm/build/bin/$CONFIG/threads/rive_text.js ../editor/web/rive_text.js
    cp wasm/build/bin/$CONFIG/threads/rive_text.worker.js ../editor/web/rive_text.worker.js
elif [[ ! -z $SIMD ]]; then
    du -hs wasm/build/bin/$CONFIG/simd/rive_text.wasm
else
    du -hs wasm/build/bin/$CONFIG/rive_text.wasm
fi
