# code map

## Main entry

- `lib/main.dart`

## UI

- `lib/views/`
  - app screens
- `lib/views/components/`
  - reusable widgets

## Controllers

- `lib/controllers/`
  - screen and workflow control
  - timer lifecycle
  - sync entrypoints

Important files:

- `controllers/timer_controller.dart`
- `controllers/sync_controller.dart`
- `controllers/home_controller.dart`
- `controllers/edit_task_controller.dart`

## Providers

- `lib/providers/`
  - Riverpod-based dependency wiring and state exposure

Important files:

- `providers/task_provider.dart`
- `providers/task_collection.dart`
- `providers/task_review/`

## Services

- `lib/services/`
  - task persistence and remote access
  - export/import style support logic
  - haptic, theme, and notification support

Important files:

- `services/common_task_service.dart`
- `services/local_task_service.dart`
- `services/remote_task_service.dart`
- `services/task_exporter.dart`
- `services/task_importer.dart`

## Auth

- `lib/services/auth/`

## Models

- `lib/models/`
  - task entities
  - pomodoro models
  - review and session data

## Utilities

- `lib/utils/`
  - env loading
  - logger
  - file log output
  - startup helpers
