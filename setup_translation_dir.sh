#!/usr/bin/env bash
set -e

echo "=== EdgeTX Build Environment Setup ==="
echo "make sure to edit to YOUR local DEFAULT_TRANSLATIONS_DIR , only adjust the next command in this script"
echo "left mine as an example"

# --- Define Default Translations Directory ---
DEFAULT_TRANSLATIONS_DIR="/home/kingstarking/edgetx/edgetx-2025-10-27-MASTER/edgetx/radio/src/translations/"

# --- Allow for an override through the TRANSLATIONS_DIR environment variable ---
TRANSLATIONS_DIR="${TRANSLATIONS_DIR:-$DEFAULT_TRANSLATIONS_DIR}"

# --- Check if the translations directory exists ---
if [[ ! -d "$TRANSLATIONS_DIR" ]]; then
    echo "ERROR: Translations directory '$TRANSLATIONS_DIR' does not exist."
    echo "Please check the path or set the TRANSLATIONS_DIR environment variable."
    exit 1
fi

echo "Using translations from: $TRANSLATIONS_DIR"

# --- Additional Script Logic Goes Here ---
# Example: Handle translation-related tasks
# cd "$TRANSLATIONS_DIR"
# ./generate_translations.sh
