#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building ZMK firmware locally..."
echo "================================"

# Clean previous builds
rm -rf "$SCRIPT_DIR/build"
mkdir -p "$SCRIPT_DIR/build"

echo ""
echo "Building left side..."
docker run --rm \
  -v "$SCRIPT_DIR/config:/zmk-config/config" \
  -v "$SCRIPT_DIR/build:/zmk-config/build" \
  zmkfirmware/zmk-build-arm:stable \
  -d /zmk-config \
  -b nice_nano_v2 \
  -s corne_left

echo ""
echo "Building right side with nice_view..."
docker run --rm \
  -v "$SCRIPT_DIR/config:/zmk-config/config" \
  -v "$SCRIPT_DIR/build:/zmk-config/build" \
  zmkfirmware/zmk-build-arm:stable \
  -d /zmk-config \
  -b nice_nano_v2 \
  -s "corne_right nice_view_adapter nice_view"

echo ""
echo "Build complete! Firmware files:"
ls -lh "$SCRIPT_DIR/build"/*.uf2
