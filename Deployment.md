# Deployment

## Prerequisites

You need to have these installed on your machine:
- GCP account & `glcoud`
- Rust & Cargo

TBD

## Compression

Install `wasm-opt` and `brotli`:
- Binaryen: https://github.com/WebAssembly/binaryen/releases
- Brotli: https://github.com/google/brotli/releases

First, compile the Rust code to WebAssembly:
```shell
cargo build --target wasm32-unknown-unknown --release
wasm-bindgen target/wasm32-unknown-unknown/release/potato-shooter.wasm --out-dir static --web
```

Then, compress the WebAssembly file:

In `./static` folder
```shell
wasm-opt potato-shooter_bg.wasm -o output.wasm -0z
brotli -q 9 output.wasm -o output.wasm.br
```