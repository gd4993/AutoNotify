# Quick Build Guide for AutoNotify APK

## Option 1: GitHub Actions (Recommended - Free)

### Step 1: Create GitHub Repository
1. Go to https://github.com/new
2. Name your repository (e.g., "AutoNotify")
3. Make it Public
4. Click "Create repository"

### Step 2: Upload Code
```bash
# In your project directory
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/AutoNotify.git
git push -u origin main
```

### Step 3: Trigger Build
1. Go to your repository on GitHub
2. Click the **Actions** tab
3. Click **"Build Android APK"** workflow
4. Click **"Run workflow"**
5. Wait 5-10 minutes

### Step 4: Download APK
1. Click on the completed workflow run
2. Scroll down to "Artifacts"
3. Download **AutoNotify-Debug-APK**
4. Extract the ZIP to get `app-debug.apk`

---

## Option 2: Gitpod (Free - No Setup)

### Step 1: Open in Gitpod
1. Go to https://gitpod.io/#https://github.com/YOUR_USERNAME/AutoNotify
2. Sign in with GitHub
3. Wait for the workspace to start

### Step 2: Build
The build will start automatically. Wait for it to complete.

### Step 3: Download
1. Open the file explorer on the left
2. Navigate to `app/build/outputs/apk/debug/`
3. Right-click `app-debug.apk`
4. Click **Download**

---

## Option 3: Android Studio (Local Build)

### Prerequisites
- Download [Android Studio](https://developer.android.com/studio)
- Install Java 17 or higher

### Steps
1. Open Android Studio
2. Click **File** → **Open**
3. Select the `AutoNotifyAndroid` folder
4. Wait for Gradle sync (first time takes ~10 minutes)
5. Click **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
6. Click the notification to locate the APK

---

## Option 4: Command Line (Local Build)

### Prerequisites
- Java 17 or higher
- Internet connection

### Steps
1. Open terminal in project directory
2. Run the build script:
   ```bash
   bash build-apk.sh
   ```
3. Wait for downloads and build (~15-20 minutes first time)
4. APK will be at: `app/build/outputs/apk/debug/app-debug.apk`

---

## Option 5: Docker Build

### Prerequisites
- Docker installed

### Steps
1. Build Docker image:
   ```bash
   docker build -t autonotify-build .
   ```
2. Run container:
   ```bash
   docker run -v $(pwd)/output:/output autonotify-build
   ```
3. APK will be in `./output/` folder

---

## Option 6: Online CI Services

### Travis CI
1. Go to https://travis-ci.com
2. Sign in with GitHub
3. Enable your repository
4. Push code to trigger build

### CircleCI
1. Go to https://circleci.com
2. Sign in with GitHub
3. Set up project
4. Build will start automatically

### AppVeyor
1. Go to https://ci.appveyor.com
2. Sign in with GitHub
3. Add new project
4. Build will start automatically

### Codemagic
1. Go to https://codemagic.io
2. Sign in with GitHub
3. Add new app
4. Build using the provided `codemagic.yaml`

---

## Installing the APK

### Enable Developer Options
1. Go to **Settings** → **About phone**
2. Tap **Build number** 7 times
3. Enter your PIN

### Enable USB Debugging
1. Go to **Settings** → **System** → **Developer options**
2. Turn on **USB debugging**

### Install APK
```bash
adb install app-debug.apk
```

Or:
1. Copy APK to phone
2. Tap to install
3. Allow installation from unknown sources if prompted

---

## Grant Notification Access

1. Open AutoNotify app
2. Tap **"Enable Access"**
3. Go to **Settings** → **Apps** → **Special app access** → **Notification access**
4. Enable **AutoNotify**
5. Return to the app

---

## Troubleshooting

### Build Fails - Gradle Sync Error
- Check internet connection
- Try **File** → **Invalidate Caches / Restart**
- Update Gradle wrapper: `./gradlew wrapper --gradle-version 8.4`

### Build Fails - SDK Not Found
- Set `ANDROID_HOME` environment variable
- Or create `local.properties` with: `sdk.dir=/path/to/android/sdk`

### App Shows "Enable Access" Even After Granting
- Restart the app
- Check if notification access is enabled in system settings
- Re-enable notification access

### Replies Not Working
- Not all apps support direct replies
- Supported: Messages, WhatsApp, Telegram, Slack, most SMS apps
- Make sure the original notification has a reply action

---

## Need Help?

- Open an issue on GitHub
- Check the README.md for more details
- Review BUILD.md for advanced build options
