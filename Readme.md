<div align="center">

# Potato Shooter

### A 2-player online deathmatch shooter in Rust with rollback netcode

![Rust](https://img.shields.io/badge/Rust-000000?style=for-the-badge&logo=rust&logoColor=white)
![Bevy](https://img.shields.io/badge/Bevy-232326?style=for-the-badge&logo=bevy&logoColor=white)
![GGRS](https://img.shields.io/badge/GGRS_Rollback-2A2A2A?style=for-the-badge)
![Matchbox](https://img.shields.io/badge/Matchbox_WebRTC-2A2A2A?style=for-the-badge)
![WebAssembly](https://img.shields.io/badge/WebAssembly-654FF0?style=for-the-badge&logo=webassembly&logoColor=white)
![Google Cloud](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=googlecloud&logoColor=white)
[![Repo](https://img.shields.io/badge/GitHub-jackinf%2Fpotato--shooter-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/jackinf/potato-shooter)

</div>

## Overview

Potato Shooter is a fast-paced, two-player online deathmatch built with the [Bevy](https://bevyengine.org/) game engine in Rust. Two peers connect through a [Matchbox](https://github.com/johanhelsing/matchbox) WebRTC signalling server and play in a deterministic, rollback-networked match powered by [GGRS](https://github.com/gschup/ggrs) (`bevy_ggrs`). Each round generates a fresh procedurally-built arena of walls; players run, gun, and dodge bullets until one is hit, and the live score is tracked across rounds.

The game compiles to native binaries and to WebAssembly, so it can run directly in the browser.

## Features

- **2-player peer-to-peer multiplayer** via WebRTC using `bevy_matchbox`.
- **Rollback netcode** with GGRS for lag-tolerant, deterministic play, including desync detection and a sync-test mode.
- **Procedurally generated arenas** — each round seeds a deterministic RNG (`rand_xoshiro`) to spawn a new layout of walls and player positions.
- **Deterministic gameplay** with checksummed `Transform` state to keep both peers in sync.
- **In-game score UI** rendered with `bevy_egui`.
- **Wall and bullet collision** resolution, bullet reloading, and round-end timing.
- **Configurable input delay** via command-line arguments (`clap`).
- **Native and WebAssembly builds** from the same codebase.

## Tech Stack

| Area | Technology |
| --- | --- |
| Language | Rust (2021 edition) |
| Engine | [Bevy](https://bevyengine.org/) 0.13 |
| Netcode | `bevy_ggrs` (GGRS rollback), `bevy_roll_safe` |
| Networking | `bevy_matchbox` (WebRTC / Matchbox) |
| UI | `bevy_egui` |
| Assets | `bevy_asset_loader` |
| RNG | `rand`, `rand_xoshiro` |
| CLI | `clap` |
| Config | `dotenv` |
| Targets | Native (`x86_64-pc-windows-msvc`) and WebAssembly (`wasm32-unknown-unknown`) |
| Deploy | Google Cloud (GCP), `wasm-bindgen` + `wasm-opt` + `brotli` |

## Getting Started

### Prerequisites

- [Rust & Cargo](https://www.rust-lang.org/tools/install)
- [`watchexec-cli`](https://github.com/watchexec/watchexec) for hot-reloading during development:
  ```shell
  cargo install watchexec-cli
  ```
- For WebAssembly builds: the `wasm32-unknown-unknown` target (the `make wasm-build` target installs `wasm-bindgen-cli` for you):
  ```shell
  rustup target add wasm32-unknown-unknown
  ```
- A reachable [Matchbox](https://github.com/johanhelsing/matchbox) signalling server for online play (the room URL is configured in `src/main.rs`).

### Installation

```shell
git clone https://github.com/jackinf/potato-shooter.git
cd potato-shooter
```

### Running

Run the web (WebAssembly) target with hot reload:

```shell
make web
```

Run the native target with hot reload:

```shell
make native
```

Run a local deterministic sync test (no networking required):

```shell
cargo run -- --synctest
```

### Building for WebAssembly

```shell
make wasm-build
```

This installs `wasm-bindgen-cli`, builds the release `wasm32-unknown-unknown` target, runs `wasm-bindgen`, and copies the `static/` assets into the output directory.

## Releasing

Build a release binary:

```shell
cargo build --release
```

Package the build on Windows:

```powershell
New-Item -ItemType Directory -Path release_package
Copy-Item -Path .\target\release\potato-shooter.exe -Destination release_package
Copy-Item -Path assets -Destination release_package -Recurse

Compress-Archive -Path release_package -DestinationPath bevy-game-release.zip
```

Create a release on GitHub:

```shell
gh release create v1.0.0 ./bevy-game-release.zip --repo jackinf/potato-shooter --title "Initial release of Potato Shooter" --notes "This is the initial release of Potato Shooter. Includes all game assets and executable."
```

See [Deployment.md](Deployment.md) for GCP deployment and WebAssembly compression (`wasm-opt`, `brotli`) details.

## Project Structure

```
potato-shooter/
├── src/
│   ├── main.rs         # App setup, game loop, systems (movement, firing, collisions, map gen)
│   ├── args.rs         # CLI argument parsing (clap)
│   ├── components.rs   # ECS components (Player, Bullet, Wall, Scores, ...)
│   └── input.rs        # Local input handling and direction/fire decoding
├── assets/             # Game assets (bullet.png)
├── static/             # WebAssembly host page (index.html, main.js, audio)
├── gcp/                # Google Cloud deployment files
├── Makefile            # Build/run/deploy targets
├── Deployment.md       # Deployment & compression notes
└── Cargo.toml          # Crate manifest & dependencies
```
