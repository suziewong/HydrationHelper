# 💧 HydrationHelper

A simple and elegant macOS menu bar app that reminds you to stay hydrated throughout the day.

![Platform](https://img.shields.io/badge/platform-macOS-blue.svg)
![Swift](https://img.shields.io/badge/swift-5.0-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ Features

- **Menu Bar Integration**: Lives in your macOS status bar with a water drop icon 💧
- **Customizable Timer**: Set reminders for 45, 60, or 90 minutes
- **Reliable Notifications**: Multiple notification methods (UNUserNotificationCenter, NSUserNotificationCenter, AppleScript) to ensure you never miss a reminder
- **Hydration History**: Track your daily and total water intake
- **Persistent Settings**: Your preferences are saved automatically
- **Clean UI**: Minimalist design following macOS Human Interface Guidelines

## 📸 Screenshots

> ![Main Interface](screenshots/main-interface.png)
> *Main popover interface showing timer and controls*

> ![Notification](screenshots/notification.png)
> *System notification reminder*

## 🚀 Installation

### Requirements
- macOS 11.0 (Big Sur) or later
- Xcode 13.0 or later (for building from source)

### Build from Source

1. Clone the repository:
```bash
git clone https://github.com/suziewong/HydrationHelper.git
cd HydrationHelper
```

2. Open in Xcode:
```bash
open HydrationHelper.xcodeproj
```

3. Build and run (⌘+R)

### Download Pre-built Binary
> Coming soon...

## 🎯 Usage

1. **Start the Timer**: Click the 💧 icon in your status bar, then click "开始" (Start)
2. **Wait for Reminder**: The app will notify you when time's up
3. **Mark as Complete**: Click "已完成喝水" after drinking
4. **Track Progress**: View today's hydration count in the app

## ⚙️ Configuration

- **Interval Settings**: Choose between 45, 60, or 90 minute intervals
- **Auto-start**: Timer remembers your last setting
- **History**: All records persist across app restarts

## 🛠️ Technical Details

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **AppKit**: Status bar integration via `NSStatusBar`
- **Multiple Notification Methods**:
  - **UNUserNotificationCenter**: Modern macOS notification API (preferred)
  - **NSUserNotificationCenter**: Legacy notification API (backup)
  - **AppleScript**: Fallback method to ensure notifications always work
- **UserDefaults**: Lightweight data persistence
- **Combine**: Reactive programming for timer updates

### Project Structure
```
HydrationHelper/
├── HydrationHelperApp.swift      # App entry point
├── ContentView.swift             # Main UI
├── StatusBarController.swift     # Menu bar management
├── TimerManager.swift            # Countdown logic
├── NotificationManager.swift     # System notifications
├── HistoryStore.swift            # Data persistence
└── Assets.xcassets/              # App icons and assets
```

### Support Scripts
```
HydrationHelper/
├── test_notification.py          # Test notification functionality
├── force_notification_permission.py # Force notification permission request
├── debug_notification.py         # Debug notification issues
├── diagnose_notification.py      # Diagnose notification problems
├── fix_notification.sh           # Fix notification permissions
├── fix_notification_permission.sh # Fix notification permissions
├── reinstall_app.sh              # Reinstall the app
├── run_and_monitor.sh            # Run app and monitor logs
├── test_app.sh                   # Comprehensive app test
└── generate_icons.py             # Generate app icons
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add some amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the importance of staying hydrated
- Built with ❤️ using SwiftUI and AppKit

---

**Stay hydrated, stay healthy! 💧**