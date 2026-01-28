# Building AutoNotify APK

## Option 1: Build with GitHub Actions (Easiest)

1. **Fork or Upload to GitHub**
   ```bash
   # Create a new repository on GitHub
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/AutoNotify.git
   git push -u origin main
   ```

2. **Trigger Build**
   - Go to your GitHub repository
   - Click **Actions** tab
   - Click **Build APK** workflow
   - Click **Run workflow**

3. **Download APK**
   - Wait for build to complete (~5 minutes)
   - Click on the completed workflow
   - Download `debug-apk` artifact
   - Extract to get `app-debug.apk`

## Option 2: Build Locally with Android Studio

### Prerequisites
- [Android Studio](https://developer.android.com/studio) (latest version)
- Java 17 or higher

### Steps

1. **Open Project**
   - Launch Android Studio
   - Click **Open** and select the `AutoNotifyAndroid` folder
   - Wait for Gradle sync to complete

2. **Build APK**
   - Click **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
   - Or press `Ctrl+Shift+F10` (Windows/Linux) or `Cmd+Shift+F10` (Mac)

3. **Locate APK**
   - Click the notification that appears
   - Or find at: `app/build/outputs/apk/debug/app-debug.apk`

4. **Install on Device**
   - Enable **Developer Options** → **USB Debugging** on your phone
   - Connect phone via USB
   - Click **Run** button in Android Studio
   - Or use ADB: `adb install app-debug.apk`

## Option 3: Build with Command Line

### Prerequisites
- Java 17 or higher
- Android SDK

### Setup Android SDK

1. **Download SDK** (one-time setup)
   ```bash
   # Linux/Mac
   mkdir -p ~/Android/Sdk
   cd ~/Android/Sdk
   
   # Download command line tools
   wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
   unzip commandlinetools-linux-9477386_latest.zip
   mkdir -p cmdline-tools/latest
   mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true
   ```

2. **Set Environment Variables**
   ```bash
   export ANDROID_HOME=$HOME/Android/Sdk
   export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools
   ```

3. **Install Build Tools**
   ```bash
   sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
   ```

### Build

```bash
cd AutoNotifyAndroid
./gradlew assembleDebug
```

APK will be at: `app/build/outputs/apk/debug/app-debug.apk`

## Option 4: Build with Docker

```bash
# Run build in Docker container
docker run --rm -v "$PWD":/project \
  -w /project \
  mingc/android-build-box \
  bash -c "./gradlew assembleDebug"
```

## Troubleshooting

### Gradle Sync Failed
- Check internet connection
- Try **File** → **Invalidate Caches / Restart**
- Update Gradle in `gradle/wrapper/gradle-wrapper.properties`

### Build Failed - SDK Not Found
- Set `ANDROID_HOME` environment variable
- Or create `local.properties` file:
  ```
  sdk.dir=/path/to/your/Android/Sdk
  ```

### Out of Memory
- Increase Gradle memory in `gradle.properties`:
  ```
  org.gradle.jvmargs=-Xmx4g
  ```

## Release Build

For release builds, you need to sign the APK:

1. **Create Keystore**
   ```bash
   keytool -genkey -v -keystore autonotify.keystore -alias autonotify -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Configure Signing**
   Create `app/keystore.properties`:
   ```
   storeFile=../autonotify.keystore
   storePassword=YOUR_PASSWORD
   keyAlias=autonotify
   keyPassword=YOUR_PASSWORD
   ```

3. **Build Release**
   ```bash
   ./gradlew assembleRelease
   ```

APK will be at: `app/build/outputs/apk/release/app-release.apk`
