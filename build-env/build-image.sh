#!/bin/bash

DOCKERFILE_VARIATION=${1:-"ubuntu"}
BASE_IMAGE_VERSION=${2:-"20.04"}
shift 2

BASE_IMAGE_NAME="${DOCKERFILE_VARIATION}${BASE_IMAGE_VERSION}"

# Build image
cd "$(dirname "$0")"

../.build-image.sh \
    --image-name-suffix "${BASE_IMAGE_NAME}" \
    --dockerfile-variation "${DOCKERFILE_VARIATION}" \
    --build-arg "BASE_IMAGE_VERSION=${BASE_IMAGE_VERSION}" \
    "$@"
