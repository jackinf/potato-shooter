# Variables
PROJECT_ID=rust-gamedev
REGION=europe-west4
BUCKET_NAME=gs://potato-shooter-wasm/
IMAGE_NAME=potato-shooter
IMAGE_URI=gcr.io/$(PROJECT_ID)/$(IMAGE_NAME)
WASM_TARGET=wasm32-unknown-unknown
WASM_DIR=out

# Phony targets
.PHONY: all wasm-build serve-web

all: wasm-build

wasm-build:
	cargo install wasm-bindgen-cli
	cargo build --target $(WASM_TARGET) --release
	wasm-bindgen target/$(WASM_TARGET)/release/$(IMAGE_NAME).wasm --out-dir $(WASM_DIR) --web
	rm static/$(IMAGE_NAME).js
	rm static/$(IMAGE_NAME).d.ts
	cp $(WASM_DIR)/$(IMAGE_NAME).js static/$(IMAGE_NAME).js
	cp $(WASM_DIR)/$(IMAGE_NAME).d.ts static/$(IMAGE_NAME).d.ts

serve-web:
	watchexec -r cargo run