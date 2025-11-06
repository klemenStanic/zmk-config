# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a ZMK (Zephyr Mechanical Keyboard) firmware configuration repository for a Corne keyboard with nice!nano v2 controllers. ZMK is a modern, wireless-first keyboard firmware built on the Zephyr RTOS.

## Architecture

### Build System
- **West manifest**: `config/west.yml` defines the ZMK dependency (pulls from zmkfirmware/zmk main branch)
- **Build matrix**: `build.yaml` configures GitHub Actions to build:
  - Left half: nice_nano_v2 + corne_left
  - Right half: nice_nano_v2 + corne_right + nice_view_adapter + nice_view (display)
- **CI/CD**: `.github/workflows/build.yml` delegates to ZMK's reusable workflow

### Configuration Files
- **Keymap**: `config/corne.keymap` - Device tree source defining keyboard behavior
  - Layer 0 (Main): Base QWERTY layout with modifier keys
  - Layer 1 (Numbers): Numbers, symbols, and special characters
  - Layer 2 (Nav): Function keys, media controls, navigation arrows, and Bluetooth profiles
  - Custom behavior: `tp` (tap-preferred hold-tap) for dual-function keys
- **Board config**: `config/corne.conf` - Kconfig options for hardware features
  - Display enabled (CONFIG_ZMK_DISPLAY=y)
  - Sleep configuration (30s idle, 15min deep sleep)
  - Bluetooth TX power boost enabled
  - External power control enabled

### Keymap Structure
The keymap uses ZMK's devicetree syntax:
- Behaviors defined in `/behaviors` node (e.g., tap-preferred hold-tap)
- Layers defined in `/keymap` node with `bindings` arrays matching physical layout (3x6 + 3 thumb keys per side)
- Key bindings use ZMK behavior macros: `&kp` (keypress), `&mo` (momentary layer), `&tp` (custom tap-preferred), `&bt` (Bluetooth)

## Common Development Tasks

### Building Firmware
Builds run automatically on push via GitHub Actions. To build locally, you need a West workspace with ZMK installed (see ZMK documentation).

### Modifying the Keymap
Edit `config/corne.keymap`:
- Use `#include <dt-bindings/zmk/keys.h>` key codes
- Each layer's `bindings` array must have exactly 42 elements (36 main keys + 6 thumb keys)
- Test by pushing to GitHub - firmware artifacts will be generated

### Adjusting Hardware Settings
Edit `config/corne.conf`:
- Uncomment/add CONFIG options to enable features
- Common options: RGB underglow, display settings, Bluetooth power, sleep timers

### Bluetooth Profiles
Layer 2 includes Bluetooth profile selection (`&bt BT_SEL 0-4`) mapped to keys in the bottom left area. The keyboard supports up to 5 paired devices.

### Custom Shields
The `boards/shields/` directory is reserved for custom shield definitions (currently empty). Add shield overlay files here if creating a custom board variant.

## Key Technical Details

- **Firmware**: ZMK tracks the main branch (bleeding edge)
- **Controller**: nice!nano v2 (nRF52840-based, wireless)
- **Display**: nice!view enabled on right half only
- **Power management**: Aggressive sleep settings for battery life
- **Layout**: Standard Corne 42-key (3x6 + 3 thumb cluster per side)
