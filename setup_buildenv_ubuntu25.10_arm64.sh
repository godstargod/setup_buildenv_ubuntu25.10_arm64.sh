#!/usr/bin/env bash
set -e

echo "=== EdgeTX Build Environment Setup for Ubuntu 25.10 ARM64 (aarch64) ==="

# --- OS & Architecture Checks ---
OS_VERSION=$(lsb_release -rs)
ARCH=$(uname -m)

if [[ "$OS_VERSION" != "25.10" ]]; then
    echo "ERROR: This script is intended for Ubuntu 25.10"
    exit 1
fi

if [[ "$ARCH" != "aarch64" ]]; then
    echo "ERROR: This script is only for ARM64 (aarch64) architecture"
    exit 1
fi

# --- System Update ---
echo "=== Updating system packages ==="
sudo apt update -y
sudo apt upgrade -y

# --- Core Build Dependencies ---
echo "=== Installing core build dependencies ==="
sudo apt install -y \
    build-essential \
    cmake \
    ninja-build \
    git \
    python3 \
    python3-venv \
    python3-pip \
    python3-setuptools \
    python3-pyqt6 \
    pkg-config \
    libusb-dev \
    libusb-1.0-0-dev \
    libhidapi-dev \
    libsdl2-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libclang-dev \
    libgtest-dev \
    ccache

# --- Enable ccache for GCC/G++ if not already set ---
echo "=== Checking and enabling ccache for GCC/G++ ==="
if ! grep -q 'export CC="ccache gcc"' ~/.bashrc; then
    echo 'export CC="ccache gcc"' >> ~/.bashrc
    echo 'export CXX="ccache g++"' >> ~/.bashrc
    echo "Added CC and CXX ccache wrappers to ~/.bashrc"
else
    echo "CC and CXX ccache settings already exist, skipping."
fi

# --- Qt6 Development Packages ---
echo "=== Installing Qt6 development packages ==="
sudo apt install -y \
    qt6-base-dev \
    qt6-base-dev-tools \
    qt6-tools-dev \
    qt6-tools-dev-tools \
    qt6-svg-dev \
    qt6-serialport-dev \
    qt6-multimedia-dev \
    inqml6-module-qtquick-controls \
    qml6-module-qtquick-layouts

# --- Check and Set QTDIR for Qt6 ---
echo "=== Checking and setting QTDIR for Qt6 if not already present ==="
if [[ -z "$QTDIR" ]]; then
    export QTDIR="/usr/lib/qt6"
    echo "Set QTDIR to $QTDIR"
else
    echo "QTDIR is already set to $QTDIR, skipping."
fi

# --- Add Qt6 to PATH if not already present ---
echo "=== Checking and adding Qt6 to PATH if not already present ==="
if ! grep -q '/usr/lib/qt6/bin' ~/.bashrc; then
    echo "export PATH=\$QTDIR/bin:\$PATH" >> ~/.bashrc
    echo "Added Qt6 to PATH in ~/.bashrc"
else
    echo "Qt6 is already in PATH, skipping addition."
fi



# --- Python Virtual Environment for EdgeTX ---
echo "=== Setting up Python virtual environment if not already present ==="
VENV_DIR="$HOME/edgetx-venv"
if [[ ! -d "$VENV_DIR" ]]; then
    echo "=== Setting up Python virtual environment ==="
    python3 -m venv "$VENV_DIR"
    source "$VENV_DIR/bin/activate"
    pip install --upgrade pip
    pip install \
        filelock \
        asciitree \
        jinja2 \
        pillow \
        future \
        lxml \
        lz4 \
        pyyaml \
        clang

    deactivate
else
    echo "Python virtual environment already exists at $VENV_DIR, skipping creation."
fi

echo "Note: To use EdgeTX Python packages, activate the venv with:"
echo "      source \$HOME/edgetx-venv/bin/activate"
echo "      After finishing, deactivate with: deactivate"

# --- ARM GNU Embedded Toolchain Setup ---
TOOLCHAIN_DIR="/opt/gcc-arm-none-eabi-arm64"
TOOLCHAIN_URL="https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-aarch64-arm-none-eabi.tar.xz"
DOWNLOAD_DIR="${EDGE_TX_DOWNLOAD_DIR:-$HOME/Downloads}"
mkdir -p "$DOWNLOAD_DIR"
cd "$DOWNLOAD_DIR"

# Check if the ARM64 toolchain is installed, otherwise download it
if [[ ! -d "$TOOLCHAIN_DIR" ]]; then
    echo "=== Installing ARM GNU Embedded Toolchain (ARM64 native) ==="
    wget -q --show-progress --progress=bar:force:noscroll "$TOOLCHAIN_URL"
    tar -xf arm-gnu-toolchain-14.2.rel1-aarch64-arm-none-eabi.tar.xz
    sudo mv arm-gnu-toolchain-14.2.rel1-aarch64-arm-none-eabi "$TOOLCHAIN_DIR"
else
    echo "ARM GNU Embedded Toolchain (ARM64) already installed at $TOOLCHAIN_DIR, skipping download."
fi

# --- Add ARM toolchain to PATH if not already present ---
if ! grep -q 'export PATH="/opt/gcc-arm-none-eabi-arm64/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="/opt/gcc-arm-none-eabi-arm64/bin:$PATH"' >> ~/.bashrc
    echo "Added ARM64 toolchain to PATH in ~/.bashrc"
else
    echo "ARM64 toolchain PATH already exists, skipping."
fi

# Re-source the .bashrc file to apply the changes
source ~/.bashrc
echo "ARM64 toolchain added to PATH and sourced .bashrc"

# --- DFU Utility & ModemManager ---
echo "=== Installing dfu-util and cleaning up conflicts ==="
sudo apt install -y dfu-util
echo "=== Consider Removal of ModemManager (currently skipped) ==="
#sudo apt remove -y modemmanager || true

# --- Check & Add CUPS paths to .bashrc ---
if ! grep -q 'export CUPS_INCLUDE_DIR' ~/.bashrc; then
    echo 'export CUPS_INCLUDE_DIR=/usr/include/cups' >> ~/.bashrc
    echo "Added CUPS_INCLUDE_DIR to .bashrc"
fi

if ! grep -q 'export CUPS_LIBRARIES' ~/.bashrc; then
    echo 'export CUPS_LIBRARIES=/usr/lib/aarch64-linux-gnu/libcups.so' >> ~/.bashrc
    echo "Added CUPS_LIBRARIES to .bashrc"
fi
echo "CUPS_INCLUDE_DIR and CUPS_LIBRARIES added to .bashrc if not already present."

# --- Return to home directory ---
cd "$HOME"

# --- Done ---
echo "=== Environment setup complete! ==="
echo "Python virtual environment for EdgeTX is located at $VENV_DIR"
echo "To use it in any folder, run: source $HOME/edgetx-venv/bin/activate "
echo "After finishing, run: deactivate"
echo "You can now build EdgeTX firmware, Companion, and Simulator on ARM64."

