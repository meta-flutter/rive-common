RUSTFLAGS="-Clinker-plugin-lto --emit=llvm-ir" cargo build -Z build-std=std,panic_abort -Z build-std-features=panic_immediate_abort --target aarch64-apple-darwin --profile minimize && \
/opt/homebrew/Cellar/llvm/16.0.6/bin/clang -c -Oz -flto=full -o example.o ./example.c && \
/opt/homebrew/Cellar/llvm/16.0.6/bin/clang -flto=full -L target/aarch64-apple-darwin/minimize -ltaffy_ffi -o example -Oz ./example.o && \
strip example && \
rm example.o
