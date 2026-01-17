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
  -v "$SCRIPT_DIR/config:/zmk-config/config:Z" \
  -v "$SCRIPT_DIR/build:/zmk-config/build:Z" \
  -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  /bin/bash -c '\
    west init -l config && \
    west update && \
    west build -s zmk/app -b nice_nano_v2 -d build/left -- -DZMK_CONFIG="/zmk-config/config" -DSHIELD="corne_left" && \
    cp build/left/zephyr/zmk.uf2 build/corne_left-nice_nano_v2.uf2'

echo ""
echo "Building right side with nice_view..."
docker run --rm \
  -v "$SCRIPT_DIR/config:/zmk-config/config:Z" \
  -v "$SCRIPT_DIR/build:/zmk-config/build:Z" \
  -w /zmk-config \
  zmkfirmware/zmk-build-arm:2.5 \
  /bin/bash -c '\
    west init -l config && \
    west update && \
    west build -s zmk/app -b nice_nano_v2 -d build/right -- -DZMK_CONFIG="/zmk-config/config" -DSHIELD="corne_right nice_view_adapter nice_view" && \
    cp build/right/zephyr/zmk.uf2 build/corne_right-nice_nano_v2.uf2'

echo ""
echo "Build complete! Firmware files:"
ls -lh "$SCRIPT_DIR/build"/*.uf2 2>/dev/null || echo "No .uf2 files found"
