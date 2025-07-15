# Docker Image Builder

A flexible and extensible Docker image management system for building various development environments and project binaries.

## Overview

This project provides a framework for building and managing Docker images for different development purposes:

- **Base development environments** for C/C++/Rust projects
- **Legacy project binaries** compilation environments
- **OS-specific terminal development environments**
- **Research experiment reimplementation** environments
- **Custom development toolchains** and build environments

## Features

- **Automatic versioning**: Tracks Dockerfile changes and manages semantic versioning
- **Multi-variation support**: Build different variations of the same base environment
- **Build argument management**: Flexible parameter passing to Docker builds
- **Dry-run capability**: Preview build commands before execution
- **Extensible architecture**: Easy to add new Dockerfile variations and build configurations

## Project Structure

```
docker/
├── .build-image.sh          # Core build script with versioning logic
├── build-env/               # Development environment images
│   ├── Dockerfile.ubuntu    # Ubuntu-based development environment
│   ├── build-image.sh       # Ubuntu-specific build wrapper
│   └── .version.ubuntu      # Version tracking for Ubuntu variation
└── README.md               # This file
```

## Quick Start

### Building a Development Environment

```bash
# Build Ubuntu 20.04 development environment
./build-env/build-image.sh ubuntu 20.04

# Build Ubuntu 22.04 development environment
./build-env/build-image.sh ubuntu 22.04

# Preview build command without executing
./build-env/build-image.sh ubuntu 20.04 --dry-run
```

### Core Build Script Usage

```bash
# Direct usage of the core build script
./.build-image.sh \
    --image-name-suffix "ubuntu20" \
    --dockerfile-variation "ubuntu" \
    --build-arg "BASE_IMAGE_VERSION=20.04"
```

## Available Environments

### Ubuntu Development Environment (`build-env/`)

**Base Image**: Ubuntu 20.04/22.04

**Included Tools**:
- `autoconf`, `automake`, `build-essential` - C/C++ build tools
- `cmake` - Cross-platform build system
- `git` - Version control
- `libtool` - Library management
- `libeigen3-dev` - Linear algebra library
- `libssl-dev` - SSL/TLS development libraries
- `pkg-config` - Package configuration tool

**Usage**:
```bash
# Build with default Ubuntu 20.04
./build-env/build-image.sh

# Build with specific Ubuntu version
./build-env/build-image.sh ubuntu 22.04

# Build with custom build arguments
./build-env/build-image.sh ubuntu 20.04 --build-arg "CUSTOM_ARG=value"
```

## Version Management

The system automatically tracks Dockerfile changes and manages semantic versioning:

- **Major version** (x.0.0): Breaking changes
- **Minor version** (x.y.0): New features, backward compatible
- **Patch version** (x.y.z): Bug fixes, backward compatible

Version files (`.version.*`) store the current version and MD5 hash of the Dockerfile to detect changes.

## Extending the Framework

### Adding a New Environment

1. **Create a new directory** for your environment:
   ```bash
   mkdir my-env
   ```

2. **Create a Dockerfile variation**:
   ```dockerfile
   # my-env/Dockerfile.debian
   ARG BASE_IMAGE_VERSION=11
   
   FROM debian:${BASE_IMAGE_VERSION}
   # ... your environment setup
   ```

3. **Create a build wrapper script**:
   ```bash
   #!/bin/bash
   # my-env/build-image.sh
   
   DOCKERFILE_VARIATION=${1:-"debian"}
   BASE_IMAGE_VERSION=${2:-"11"}
   shift 2
   
   BASE_IMAGE_NAME="${DOCKERFILE_VARIATION}${BASE_IMAGE_VERSION}"
   
   cd "$(dirname "$0")"
   
   ../.build-image.sh \
       --image-name-suffix "${BASE_IMAGE_NAME}" \
       --dockerfile-variation "${DOCKERFILE_VARIATION}" \
       --build-arg "BASE_IMAGE_VERSION=${BASE_IMAGE_VERSION}" \
       "$@"
   ```

4. **Make the script executable**:
   ```bash
   chmod +x my-env/build-image.sh
   ```

### Adding a New Dockerfile Variation

1. **Create a new Dockerfile** in an existing environment:
   ```dockerfile
   # build-env/Dockerfile.alpine
   ARG BASE_IMAGE_VERSION=3.18
   
   FROM alpine:${BASE_IMAGE_VERSION}
   # ... your Alpine-specific setup
   ```

2. **Update the build script** to support the new variation:
   ```bash
   # In build-env/build-image.sh, add support for alpine
   DOCKERFILE_VARIATION=${1:-"ubuntu"}
   ```

## Best Practices

### Environment Organization

- **Group related environments** in dedicated directories
- **Use descriptive names** for Dockerfile variations
- **Document dependencies** and build requirements
- **Include usage examples** in environment-specific READMEs

### Version Management

- **Use semantic versioning** consistently
- **Document breaking changes** in version files
- **Test builds** before committing version updates
- **Tag releases** in git for important versions

### Build Optimization

- **Layer caching**: Order Dockerfile instructions from least to most frequently changing
- **Multi-stage builds**: Use for complex build processes
- **Build arguments**: Make images configurable without rebuilding
- **Base image selection**: Choose appropriate base images for your use case

## Contributing

1. **Fork the repository**
2. **Create a feature branch** for your changes
3. **Add your environment** following the extension guidelines
4. **Test your builds** thoroughly
5. **Submit a pull request** with documentation

## License

[Add your license information here]

## Support

For issues, questions, or contributions, please open an issue on the project repository. 