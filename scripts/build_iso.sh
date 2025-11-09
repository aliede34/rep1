#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
BUILD_DIR="$PROJECT_ROOT/build"
KERNEL="$BUILD_DIR/kernel.elf"
GRUB_CFG="$PROJECT_ROOT/src/grub.cfg"
OUTPUT="${1:-$BUILD_DIR/os.iso}"
NASM="${NASM:-nasm}"

if [ ! -f "$GRUB_CFG" ]; then
    echo "Cannot find GRUB configuration at $GRUB_CFG" >&2
    exit 1
fi

if [ ! -f "$KERNEL" ]; then
    if ! command -v "$NASM" >/dev/null 2>&1; then
        echo "Error: NASM assembler ($NASM) not found in PATH." >&2
        echo "Install NASM (e.g. sudo apt install nasm, brew install nasm, or pacman -S nasm on MSYS2) and retry." >&2
        exit 1
    fi

    echo "Kernel image not found at $KERNEL. Building it first..."
    make -C "$PROJECT_ROOT" NASM="$NASM" kernel
fi

missing_deps=()
for dep in grub-mkrescue xorriso; do
    if ! command -v "$dep" >/dev/null 2>&1; then
        missing_deps+=("$dep")
    fi
done

if [ ${#missing_deps[@]} -ne 0 ]; then
    printf 'The following required tools are missing: %s\n' "${missing_deps[*]}" >&2
    echo "Please install them (e.g. on Debian/Ubuntu: sudo apt-get install grub-pc-bin xorriso)." >&2
    exit 1
fi

iso_root=$(mktemp -d)
trap 'rm -rf "$iso_root"' EXIT

mkdir -p "$iso_root/boot/grub"
cp "$KERNEL" "$iso_root/boot/kernel.elf"
cp "$GRUB_CFG" "$iso_root/boot/grub/grub.cfg"

mkdir -p "$BUILD_DIR"

grub-mkrescue -o "$OUTPUT" "$iso_root"

echo "ISO created at: $OUTPUT"
