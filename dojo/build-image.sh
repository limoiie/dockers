#!/bin/bash

DOCKERFILE_VARIATION=${1:-"kali-rolling"}
BASE_IMAGE_VERSION=${2:-"latest"}
shift 2

# Build image
cd "$(dirname "$0")"

../.build-image.sh \
    --base-image-name "${DOCKERFILE_VARIATION}" \
    --base-image-version "${BASE_IMAGE_VERSION}" \
    --dockerfile-variation "${DOCKERFILE_VARIATION}" \
    --build-arg "BASE_IMAGE_VERSION=${BASE_IMAGE_VERSION}" \
    "$@"
