# Potato Shooter

## Quickstart

```shell
cargo install watchexec-cli
```

```shell
make web
```

## Deploying

Refer to [Deployment.md](Deployment.md) for more information.

## Releasing

Build for release
```shell
cargo build --release
```

Create zip with Windows
```powershell
New-Item -ItemType Directory -Path release_package
Copy-Item -Path .\target\release\potato-shooter.exe -Destination release_package
Copy-Item -Path assets -Destination release_package -Recurse

Compress-Archive -Path release_package -DestinationPath bevy-game-release.zip 
```

Create a release on GitHub
```shell
gh release create v1.0.0 ./bevy-game-release.zip --repo jackinf/potato-shooter --title "Initial release of Potato Shooter" --notes "This is the initial release of Potato Shooter. Includes all game assets and executable."
```