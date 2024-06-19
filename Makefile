# Variables
PROJECT_ID=rust-gamedev
REGION=europe-west4
BUCKET_NAME=gs://potato-shooter-wasm/
IMAGE_NAME=potato-shooter
IMAGE_URI=gcr.io/$(PROJECT_ID)/$(IMAGE_NAME)
WASM_TARGET=wasm32-unknown-unknown
NATIVE_TARGET=x86_64-pc-windows-msvc
WASM_DIR=out

# Phony targets
.PHONY: all wasm-build serve-web

all: wasm-build

wasm-build:
	cargo install wasm-bindgen-cli
	cargo build --target $(WASM_TARGET) --release
	wasm-bindgen target/$(WASM_TARGET)/release/$(IMAGE_NAME).wasm --out-dir $(WASM_DIR) --web
	cp static/* $(WASM_DIR)

web:
	watchexec -r cargo run --target $(WASM_TARGET)

native:
	watchexec -r cargo run --target $(NATIVE_TARGET)

synctest:
	run --package $(IMAGE_NAME) --bin $(IMAGE_NAME) -- --synctest

wasm-build-raw:
	cargo build --target wasm32-unknown-unknown --release
	wasm-bindgen target/wasm32-unknown-unknown/release/potato-shooter.wasm --out-dir out --web
	sudo cp out/* /var/www/potato-shooter/
