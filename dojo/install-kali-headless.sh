#!/bin/bash

# Retry script for installing kali-linux-headless
# This script will attempt to install kali-linux-headless with retry logic

echo "Starting kali-linux-headless installation with retry logic..."

echo "Attempting to install kali-linux-headless..."

if apt update && apt install -y kali-linux-headless; then
    echo "Installation successful"
    exit 0
fi

echo "Attempt failed, trying with --fix-missing..."
apt update
sleep 20
if apt install --fix-missing -y kali-linux-headless; then
    echo "Installation successful with --fix-missing"
    exit 0
fi

echo "Attempt failed, trying with --fix-broken again..."
apt update
sleep 20
if apt install --fix-broken -y; then
    echo "Installation successful with --fix-broken"
    exit 0
fi

echo "Installation failed."
exit 0 