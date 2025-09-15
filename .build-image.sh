#!/bin/bash

# Function to check and manage Dockerfile version
check_dockerfile_version() {
    local dockerfile_variation
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dockerfile-variation)
                dockerfile_variation="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    local dockerfile_path="./Dockerfile.${dockerfile_variation}"
    local version_file="./.version.${dockerfile_variation}"
    
    # Calculate current MD5 of Dockerfile
    if [[ "$OSTYPE" == "darwin"* ]]; then
        current_md5=$(md5 -q "$dockerfile_path")
    else
        current_md5=$(md5sum "$dockerfile_path" | cut -d' ' -f1)
    fi
    
    # Initialize version file if it doesn't exist or is empty
    if [[ ! -f "$version_file" || ! -s "$version_file" ]]; then
        echo "0.1.0" > "$version_file"
        echo "$current_md5" >> "$version_file"
        echo "Initialized version file with version 0.1.0" >&2
        echo "0.1.0"
        return 0
    fi
    
    # Read stored version and MD5
    stored_version=$(sed -n '1p' "$version_file")
    stored_md5=$(sed -n '2p' "$version_file")
    
    # Check if Dockerfile has changed
    if [[ "$current_md5" != "$stored_md5" ]]; then
        echo "Dockerfile has changed!" >&2
        echo "Current version: $stored_version" >&2
        echo "Please select version bump type:" >&2
        echo "1) Major (x.0.0)" >&2
        echo "2) Minor (x.y.0)" >&2
        echo "3) Patch (x.y.z)" >&2
        
        while true; do
            read -p "Enter your choice (1-3): " choice >&2
            case $choice in
                1)
                    new_version=$(echo "$stored_version" | awk -F. '{print ($1+1)".0.0"}')
                    break
                    ;;
                2)
                    new_version=$(echo "$stored_version" | awk -F. '{print $1"."($2+1)".0"}')
                    break
                    ;;
                3)
                    new_version=$(echo "$stored_version" | awk -F. '{print $1"."$2"."($3+1)}')
                    break
                    ;;
                *)
                    echo "Invalid choice. Please enter 1, 2, or 3." >&2
                    ;;
            esac
        done
        
        # Update version file
        echo "$new_version" > "$version_file"
        echo "$current_md5" >> "$version_file"
        echo "Version updated to: $new_version" >&2
        
        # Return the new version
        echo "$new_version"
    else
        echo "Dockerfile unchanged. Using existing version: $stored_version" >&2
        echo "$stored_version"
    fi
}

# Build image
build_image() {
    local base_image_name=""
    local base_image_version=""
    local dockerfile_variation=""
    local build_args=()
    local dry_run=false
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --base-image-name)
                base_image_name="$2"
                shift 2
                ;;
            --base-image-version)
                base_image_version="$2"
                shift 2
                ;;
            --dockerfile-variation)
                dockerfile_variation="$2"
                shift 2
                ;;
            --build-arg)
                build_args+=("--build-arg" "$2")
                shift 2
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    local image_sub_name="$(basename "$(pwd)")"
    local image_sub_version=$(check_dockerfile_version --dockerfile-variation "${dockerfile_variation}")

    local image_name="${base_image_name}/${image_sub_name}"
    local image_version="${base_image_version}-${image_sub_version}"

    echo "Building ${image_name} with auto-version ${image_sub_version} and ${dockerfile_variation} variation"
    echo "Build args: ${build_args[*]}"

    local image_tag="${image_name}:${image_version}"
    local image_latest_tag="${image_name}:latest"
    
    if [[ "$dry_run" == true ]]; then
        echo "docker build -f ./Dockerfile.${dockerfile_variation} -t ${image_tag} ${build_args[*]} ."
        echo "docker tag ${image_tag} ${image_latest_tag}"
    else
        docker build -f "./Dockerfile.${dockerfile_variation}" -t "${image_tag}" "${build_args[@]}" .
        docker tag "${image_tag}" "${image_latest_tag}"
    fi
}

build_image "$@"