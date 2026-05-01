# GEMINI.md - ptune Project Context

## Project Overview
**ptune** is a Flutter-based Pomodoro timer application integrated with Google Tasks. It supports a workflow of "Plan → Focus → Review," allowing users to sync tasks with Google Tasks, execute them using a Pomodoro timer, and record work logs for review (often integrated with Obsidian).

### Key Technologies
- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **State Management:** [Riverpod](https://riverpod.dev/)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **Data Modeling:** [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable](https://pub.dev/packages/json_serializable)
- **Backend/Auth:** Firebase Auth & Google APIs (Google Tasks API)
- **Desktop Support:** `window_manager` for macOS, Windows, and Linux

### Architecture Structure
- `lib/models/`: Data models and Freezed/JSON logic.
- `lib/providers/`: Riverpod providers for state and logic access.
- `lib/controllers/`: Business logic and state modification.
- `lib/services/`: External API (Google Tasks), local storage (Shared Preferences/SQLite), and platform services.
- `lib/views/`: UI widgets and screens.
- `lib/utils/`: Helpers, logging, and environment configuration.

---

## Building and Running

### Prerequisites
- Flutter SDK installed (check `pubspec.yaml` for version constraints).
- A `.env` file in the root directory (copy from `.env.example`).
- Firebase configuration files (`google-services.json` for Android, `GoogleService-Info.plist` for iOS) if using Firebase mode.

### Commands
- **Install Dependencies:**
  ```bash
  flutter pub get
  ```
- **Code Generation (Crucial for Models):**
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Run the Application:**
  ```bash
  flutter run
  ```
- **Run Tests:**
  ```bash
  flutter test
  ```
- **Static Analysis:**
  ```bash
  flutter analyze
  ```

---

## Development Conventions

### General Rules
- **Surgical Changes:** Prefer small, local fixes over large structural rewrites.
- **State Management:** Rigorously follow the Riverpod pattern. Logic should reside in `Controllers` or `Providers`, not in the `Views`.
- **Generated Files:** NEVER manually edit files ending in `.g.dart` or `.freezed.dart`. Always use `build_runner` to update them.
- **Persistence:** Keep task persistence logic inside `Services`.
- **Logging:** Use the existing logging utility in `lib/utils/logger.dart` instead of `print()`.
- **Separation of Concerns:** Treat local task caching and remote Google Tasks synchronization as distinct layers.

### High-Risk Areas
- **Sync Logic:** Consistency between local cache and remote Google Tasks.
- **Timer Events:** Async updates triggered by the Pomodoro timer.
- **Authentication:** Google OAuth flows and token management.

---

## Documentation Entrypoints
For more detailed information, refer to:
- `docs/overview.md`: High-level purpose and themes.
- `docs/code-map.md`: Mapping of code components.
- `docs/maintenance-guide.md`: Guidelines for ongoing maintenance.
- `docs/task-sync-model.md`: Details on the synchronization logic.
- `AGENTS.md`: Specific rules and priorities for AI agents working on this repo.
