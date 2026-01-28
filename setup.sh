#!/bin/bash

# AutoNotify Android Build Setup Script
# This script sets up the environment for building the AutoNotify APK

set -e

echo "=== AutoNotify Build Setup ==="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2)
    echo -e "${GREEN}✓ Java found: $JAVA_VERSION${NC}"
else
    echo -e "${RED}✗ Java not found. Please install Java 17 or higher.${NC}"
    echo "  Ubuntu/Debian: sudo apt install openjdk-17-jdk"
    echo "  Mac: brew install openjdk@17"
    exit 1
fi

# Set Android SDK path
if [ -z "$ANDROID_HOME" ]; then
    if [ -d "$HOME/Android/Sdk" ]; then
        export ANDROID_HOME="$HOME/Android/Sdk"
    elif [ -d "$HOME/Library/Android/sdk" ]; then
        export ANDROID_HOME="$HOME/Library/Android/sdk"
    fi
fi

# Download Android SDK if not present
if [ -z "$ANDROID_HOME" ] || [ ! -d "$ANDROID_HOME" ]; then
    echo -e "${YELLOW}⚠ Android SDK not found. Downloading...${NC}"
    
    SDK_DIR="$HOME/Android/Sdk"
    mkdir -p "$SDK_DIR"
    cd "$SDK_DIR"
    
    # Download command line tools
    if [ ! -f "commandlinetools-linux-9477386_latest.zip" ]; then
        echo "Downloading Android SDK command line tools..."
        curl -L -o commandlinetools-linux-9477386_latest.zip \
            "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip"
    fi
    
    # Extract
    unzip -q commandlinetools-linux-9477386_latest.zip
    mkdir -p cmdline-tools/latest
    mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
    rm -f commandlinetools-linux-9477386_latest.zip
    
    export ANDROID_HOME="$SDK_DIR"
    export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"
    
    # Install required components
    echo "Installing required SDK components..."
    yes | sdkmanager --licenses 2>/dev/null || true
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
    
    echo -e "${GREEN}✓ Android SDK installed at $ANDROID_HOME${NC}"
else
    echo -e "${GREEN}✓ Android SDK found at $ANDROID_HOME${NC}"
fi

# Setup Gradle Wrapper
cd "$(dirname "$0")"

if [ ! -f "gradle/wrapper/gradle-wrapper.jar" ]; then
    echo -e "${YELLOW}⚠ Gradle wrapper not found. Downloading...${NC}"
    
    mkdir -p gradle/wrapper
    
    # Download gradle wrapper
    GRADLE_WRAPPER_URL="https://raw.githubusercontent.com/gradle/gradle/v8.4.0/gradle/wrapper"
    curl -L -o gradle/wrapper/gradle-wrapper.jar "$GRADLE_WRAPPER_URL/gradle-wrapper.jar"
    curl -L -o gradle/wrapper/gradle-wrapper.properties "$GRADLE_WRAPPER_URL/gradle-wrapper.properties"
    
    echo -e "${GREEN}✓ Gradle wrapper downloaded${NC}"
fi

# Make gradlew executable
chmod +x gradlew 2>/dev/null || true

# Create local.properties
echo "sdk.dir=$ANDROID_HOME" > local.properties

echo ""
echo -e "${GREEN}=== Setup Complete! ===${NC}"
echo ""
echo "You can now build the APK:"
echo "  ./gradlew assembleDebug"
echo ""
echo "Or open in Android Studio and click 'Build APK'"
echo ""
echo "APK will be at: app/build/outputs/apk/debug/app-debug.apk"
