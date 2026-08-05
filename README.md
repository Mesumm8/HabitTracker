# 🎯 HabitTracker

A clean, modern, and persistent cross-platform habit tracking application built with **Flutter**, **Isar Database**, and **Provider**.

---

## 📌 Overview

**HabitTracker** is designed to help users build and sustain positive habits through intuitive daily tracking, completion visualizers, and local data persistence. Built using Flutter and Dart, the application prioritizes fast offline storage, simple UI interactions, and interactive habit analytics over time.

---

## ✨ Key Features

* 📝 **Full Habit CRUD Operations**: Effortlessly create, view, update, and delete habits with custom confirmation popups and dynamic UI refresh.
* 📅 **Daily Completion Check-ins**: Toggle habit completion states for today with automated date tracking.
* 🔥 **Interactive Habit HeatMap**: Visualize habit consistency over time using a color-graded calendar heatmap powered by `flutter_heatmap_calendar`.
* ⚡ **High-Performance Local Database**: Fast, offline-first data storage powered by **Isar Database** and code generation (`build_runner`).
* 🎨 **Clean & Responsive UI**: Modular UI widgets (`MyHabitTile`, `MyHeatMap`, `MyDrawer`) adhering to clean Material 3 design principles.
* 🛡️ **State Management**: Built with the **Provider** pattern for reactive state updates across the app lifecycle.

---

## 🛠️ Tech Stack & Dependencies

| Layer / Library | Technology / Package | Description |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) (Dart) | Cross-platform mobile, web, and desktop framework |
| **State Management**| [`provider`](https://pub.dev/packages/provider) | Reactive app state management |
| **Database** | [`isar`](https://pub.dev/packages/isar) / [`isar_flutter_libs`](https://pub.dev/packages/isar_flutter_libs) | Fast, cross-platform offline NoSQL database |
| **Heatmap Grid** | [`flutter_heatmap_calendar`](https://pub.dev/packages/flutter_heatmap_calendar) | Calendar heatmap grid visualization |
| **Slidable List** | [`flutter_slidable`](https://pub.dev/packages/flutter_slidable) | Swipeable tile actions (edit/delete) |
| **Code Generation** | [`build_runner`](https://pub.dev/packages/build_runner) & [`isar_generator`](https://pub.dev/packages/isar_generator) | Automated model schemas (`.g.dart`) generation |

---

## 📁 Project Structure

```text
lib/
├── components/          # Reusable UI components
│   ├── my_drawer.dart   # Navigation drawer
│   ├── my_habit_tile.dart # Interactive habit item list tile
│   └── my_heatmap.dart  # Calendar heatmap visualization widget
├── database/            # Database controllers & persistence
│   └── habit_database.dart # Isar database CRUD operations & state provider
├── models/              # Isar database collections & models
│   ├── app_settings.dart # App launch & baseline settings schema
│   └── habit.dart       # Habit collection schema
├── pages/               # Main application screens
│   └── home_page.dart   # Dashboard screen with habits list & heatmap
├── util/                # Helper functions & utility methods
│   └── habit_util.dart  # Date formatting & completion check helpers
└── main.dart            # Application entry point & provider initialization
```

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
* [VS Code](https://code.visualstudio.com/) or Android Studio
* Dart SDK (included with Flutter)
* Target runner (Android Emulator / iOS Simulator / Desktop Host)

### Installation & Setup

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/HabitTracker.git
   cd HabitTracker
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Generate Isar Database Schemas (`.g.dart`):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the Application:**
   * **On Mobile / Desktop (Recommended for Isar FFI support):**
     ```bash
     flutter run
     ```
   * **Explicitly select device target:**
     ```bash
     flutter run -d windows    # Windows Desktop
     flutter run -d android    # Connected Android device / Emulator
     ```

---

## 📄 Usage & Workflow

1. **Create Habit**: Tap the floating `+` button on the dashboard to enter a new habit name.
2. **Track Completion**: Check the checkbox on any habit tile to mark it complete for the current day.
3. **HeatMap Analytics**: View your overall consistency patterns on the top heatmap widget.
4. **Edit / Delete**: Interact with habit options to rename or delete habits from local storage.

---

## 🤝 Contributing

Contributions are welcome! If you'd like to report bugs or request features:
1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'feat: Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information
