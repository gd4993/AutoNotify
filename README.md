# AutoNotify - Android Notification Center

A native Kotlin Android app that reads device notifications and allows quick replies, inspired by Android Auto's notification interface.

## Features

- **Read Device Notifications**: Uses Android's `NotificationListenerService` to capture all notifications
- **Easy-to-Read Interface**: Large text, high contrast, dark theme optimized for in-car use
- **Quick Replies**: Reply to messages with one tap using quick reply buttons
- **Custom Replies**: Type custom replies with a built-in keyboard
- **Mark as Read**: Swipe or tap to mark notifications as read
- **Dismiss Notifications**: Remove notifications from the list
- **Unread Counter**: Badge showing number of unread notifications

## Screenshots

The app features:
- Dark theme with blue accents (Android Auto style)
- Card-based notification list
- Large touch targets for easy interaction
- Status bar with time and connectivity info

## Requirements

- Android 8.0 (API 26) or higher
- Notification access permission

## Installation

### From Source

1. Clone or download this repository
2. Open in Android Studio
3. Sync Gradle and build the project
4. Run on your device or emulator

### Enable Notification Access

On first launch, the app will prompt you to enable notification access:

1. Go to **Settings** → **Apps** → **Special app access** → **Notification access**
2. Find **AutoNotify** and enable it
3. Return to the app

## Architecture

```
com.autonotify/
├── data/
│   ├── NotificationItem.kt          # Data model for notifications
│   └── NotificationRepository.kt    # Singleton repository for notification storage
├── service/
│   ├── NotificationListenerService.kt  # Service that captures notifications
│   └── ReplyService.kt                 # Service that handles replies
├── adapter/
│   └── NotificationAdapter.kt       # RecyclerView adapter for notification list
└── ui/
    └── MainActivity.kt              # Main activity with notification list
```

## Permissions

The app requires the following permissions:

- `BIND_NOTIFICATION_LISTENER_SERVICE` - To read notifications
- `FOREGROUND_SERVICE` - To keep the service running
- `POST_NOTIFICATIONS` - To post notifications (Android 13+)
- `SEND_SMS` - Optional, for SMS replies

## Building

### Using Android Studio

1. Open the project in Android Studio
2. Click **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
3. The APK will be generated in `app/build/outputs/apk/debug/`

### Using Command Line

```bash
./gradlew assembleDebug
```

The debug APK will be at:
```
app/build/outputs/apk/debug/app-debug.apk
```

For release build:
```bash
./gradlew assembleRelease
```

## Customization

### Colors

Edit `app/src/main/res/values/colors.xml` to customize the theme:

- `accent_blue` - Main accent color
- `background` - App background
- `card_unread` - Unread notification card background
- `card_read` - Read notification card background

### Quick Replies

Edit `NotificationAdapter.kt` to customize quick reply options:

```kotlin
val quickReplies = listOf("👍", "OK", "On my way", "Sounds good!", "Can't talk now")
```

## Troubleshooting

### Notifications not appearing

1. Make sure notification access is enabled in system settings
2. Check that the app is not battery optimized (Settings → Battery → Battery optimization)
3. Restart the app

### Reply not working

Not all apps support direct replies. The app checks for `RemoteInput` actions in notifications. Supported apps include:
- Messages
- WhatsApp
- Telegram
- Slack
- Most SMS apps

## License

MIT License - Feel free to use and modify as needed.

## Credits

- Material Design 3 components
- Android NotificationListenerService API
