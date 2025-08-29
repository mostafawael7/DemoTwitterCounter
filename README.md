# 🐦 TwitterCounter

A SwiftUI component that mimics Twitter's character count logic. Built as a modular Swift package and demo app.

## ✨ Features

- ✅ Twitter-style character counting (handles Unicode & URLs)
- ✅ Displays characters typed and remaining
- ✅ Limits to 280 characters
- ✅ Copy / Clear / Post Tweet buttons
- ✅ Twitter authentication (OAuth 2.0)
- ✅ Toast notifications
- ✅ Smooth text field clearing with fade animation
- ✅ Swift Package ready

## 📦 Package Structure

- `TwitterCounterPackage/`
  - Contains the Swift Package: `TwitterCounterView`, `TweetCounter`
- `DemoTwitterCounter/`
  - SwiftUI demo app that:
    - Integrates the package
    - Handles Twitter authentication
    - Posts tweets

## 🛠️ Installation

1. Clone the repo:
   ```bash
   git clone https://github.com/your-username/DemoTwitterCounter.git
2.	Open DemoTwitterCounter.xcodeproj
3.	The Swift Package is included locally via:
    ```bash
    .package(path: "../TwitterCounterPackage")
    ```
