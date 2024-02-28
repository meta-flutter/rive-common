#!/bin/bash
set -e

CONFIG=debug


unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=linux ;;
Darwin*) MACHINE=mac ;;
CYGWIN*) MACHINE=cygwin ;;
MINGW*) MACHINE=mingw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac


# We build Taffy here rather than using premake because it doesn't support Rust
if [[ ! -f "../shared_lib/build/bin/$CONFIG/libtaffy_ffi.dylib" ]]; then
    pushd ../taffy_ffi
    $HOME/.cargo/bin/cargo rustc --crate-type=cdylib
    mkdir -p ../shared_lib/build/bin/$CONFIG
    if [ "$MACHINE" = 'mac' ]; then
        mv target/$CONFIG/libtaffy_ffi.dylib ../shared_lib/build/bin/$CONFIG
    else
        mv target/$CONFIG/libtaffy_ffi.so ../shared_lib/build/bin/$CONFIG
    fi
    popd
fi