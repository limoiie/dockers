# Docker Image Builder

Simple scripts to build Docker images for development environments.

## What it does

- Build Ubuntu building environments with common tools
- Build Kali Linux headless environments for security work
- Track versions automatically when Dockerfiles change
- Support different base image versions

## Project Structure

```
docker/
├── .build-image.sh          # Core build script with versioning logic
├── build/                   # Ubuntu building environment images
│   ├── Dockerfile.ubuntu    # Ubuntu-based building environment
│   ├── build-image.sh       # Ubuntu-specific build wrapper
│   └── .version.ubuntu      # Version tracking for Ubuntu variation
├── dojo/                    # Kali Linux development environment images
│   ├── Dockerfile.kali-rolling    # Kali Linux headless environment
│   ├── build-image.sh             # Kali Linux-specific build wrapper
│   ├── install-kali-headless.sh  # Kali Linux installation script
│   └── .version.kali-rolling     # Version tracking for Kali variation
└── README.md               # This file
```

## Usage

```bash
# Build Ubuntu building environment
./build/build-image.sh ubuntu 20.04

# Build Kali Linux environment
./dojo/build-image.sh kali-rolling latest

# See what would be built (dry run)
./build/build-image.sh ubuntu 20.04 --dry-run
```

## Environments

### Ubuntu (`build/`)
- Base: Ubuntu 20.04/22.04
- Tools: build-essential, cmake, git, libeigen3-dev, libssl-dev, pkg-config
- Usage: `./build/build-image.sh ubuntu 20.04`

### Kali Linux (`dojo/`)
- Base: Kali Linux Rolling
- Tools: kali-linux-headless (penetration testing tools)
- Usage: `./dojo/build-image.sh kali-rolling latest`

## Adding New Environments

1. Create a new directory: `mkdir my-env`
2. Add a Dockerfile: `my-env/Dockerfile.myos`
3. Add a build script: `my-env/build-image.sh`
4. Make it executable: `chmod +x my-env/build-image.sh`

The build script should call `../.build-image.sh` with the right parameters. 