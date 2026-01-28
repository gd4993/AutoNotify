#!/bin/bash

# AutoNotify APK Build Script
# This script downloads the necessary tools and builds the APK

set -e

echo "=================================="
echo "AutoNotify APK Builder"
echo "=================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
ANDROID_SDK_VERSION="9477386"
GRADLE_VERSION="8.4"
BUILD_TOOLS_VERSION="34.0.0"
PLATFORM_VERSION="34"

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDK_DIR="${SCRIPT_DIR}/.android-sdk"
GRADLE_DIR="${SCRIPT_DIR}/.gradle"

# Function to download file with progress
download_file() {
    local url=$1
    local output=$2
    echo "Downloading $(basename $output)..."
    
    if command -v wget &> /dev/null; then
        wget --progress=bar:force -O "$output" "$url" 2>&1 | tail -20
    elif command -v curl &> /dev/null; then
        curl -L --progress-bar -o "$output" "$url"
    else
        echo -e "${RED}Error: wget or curl required${NC}"
        exit 1
    fi
}

# Check Java
echo "Checking Java..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo -e "${GREEN}✓ Java found: $JAVA_VERSION${NC}"
else
    echo -e "${RED}✗ Java not found. Please install Java 17 or higher.${NC}"
    echo "  Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "  macOS: brew install openjdk@17"
    echo "  Windows: Download from https://adoptium.net/"
    exit 1
fi

# Setup Android SDK
echo ""
echo "Setting up Android SDK..."
if [ ! -d "$SDK_DIR" ]; then
    mkdir -p "$SDK_DIR"
    
    # Download command line tools
    CMDLINE_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip"
    CMDLINE_TOOLS_ZIP="/tmp/cmdline-tools.zip"
    
    download_file "$CMDLINE_TOOLS_URL" "$CMDLINE_TOOLS_ZIP"
    
    echo "Extracting..."
    unzip -q "$CMDLINE_TOOLS_ZIP" -d "$SDK_DIR"
    mkdir -p "$SDK_DIR/cmdline-tools/latest"
    mv "$SDK_DIR/cmdline-tools/"* "$SDK_DIR/cmdline-tools/latest/" 2>/dev/null || true
    rm -f "$CMDLINE_TOOLS_ZIP"
    
    echo -e "${GREEN}✓ Android SDK downloaded${NC}"
else
    echo -e "${GREEN}✓ Android SDK already exists${NC}"
fi

# Setup environment
export ANDROID_HOME="$SDK_DIR"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

# Install required SDK components
echo ""
echo "Installing SDK components..."
echo "y" | sdkmanager --licenses > /dev/null 2>&1 || true
sdkmanager "platform-tools" "platforms;android-${PLATFORM_VERSION}" "build-tools;${BUILD_TOOLS_VERSION}"

# Setup Gradle
echo ""
echo "Setting up Gradle..."
if [ ! -d "$GRADLE_DIR" ]; then
    mkdir -p "$GRADLE_DIR"
    
    GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
    GRADLE_ZIP="/tmp/gradle.zip"
    
    download_file "$GRADLE_URL" "$GRADLE_ZIP"
    
    echo "Extracting..."
    unzip -q "$GRADLE_ZIP" -d "$GRADLE_DIR"
    rm -f "$GRADLE_ZIP"
    
    echo -e "${GREEN}✓ Gradle downloaded${NC}"
else
    echo -e "${GREEN}✓ Gradle already exists${NC}"
fi

export PATH="$PATH:$GRADLE_DIR/gradle-${GRADLE_VERSION}/bin"

# Create local.properties
echo "sdk.dir=$ANDROID_HOME" > "$SCRIPT_DIR/local.properties"

# Build APK
echo ""
echo "=================================="
echo "Building APK..."
echo "=================================="
echo ""

cd "$SCRIPT_DIR"
chmod +x gradlew

# Use local Gradle if wrapper doesn't work
if ./gradlew --version > /dev/null 2>&1; then
    ./gradlew assembleDebug
else
    echo "Using local Gradle..."
    gradle assembleDebug
fi

# Check if build succeeded
APK_PATH="$SCRIPT_DIR/app/build/outputs/apk/debug/app-debug.apk"

if [ -f "$APK_PATH" ]; then
    echo ""
    echo -e "${GREEN}==================================${NC}"
    echo -e "${GREEN}Build Successful!${NC}"
    echo -e "${GREEN}==================================${NC}"
    echo ""
    echo "APK Location: $APK_PATH"
    echo "APK Size: $(du -h "$APK_PATH" | cut -f1)"
    echo ""
    echo "To install on your device:"
    echo "  adb install \"$APK_PATH\""
    echo ""
else
    echo -e "${RED}Build failed. Check the error messages above.${NC}"
    exit 1
fi
