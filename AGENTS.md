# ptune agent guide

## Project purpose

ptune is a Flutter-based pomodoro timer and task management app.

The project is currently maintained primarily through:

- bug fixes
- small refactorings
- operational improvements

Large-scale architecture changes are not planned by default.

## Rules

- Prefer small, local fixes over structural rewrites.
- Preserve the current Flutter + Riverpod structure.
- Keep UI changes within `lib/views/` and related controllers/providers.
- Keep task persistence logic inside services, not widgets.
- Treat local task cache and remote Google Tasks sync as separate concerns.
- Be careful around timer-related async updates and deferred remote writes.
- Do not hand-edit generated files such as `*.g.dart` and `*.freezed.dart`.
- Reuse the existing logging utilities under `lib/utils/`.

## High-risk areas

- task local/remote consistency
- timer-triggered async task updates
- sync retry and export/import style flows
- Google authentication and remote task access

## First files to inspect

- `lib/providers/task_provider.dart`
- `lib/services/local_task_service.dart`
- `lib/services/remote_task_service.dart`
- `lib/controllers/sync_controller.dart`
- `lib/controllers/timer_controller.dart`
- `lib/services/common_task_service.dart`

## Documentation entrypoints

- `docs/README.md`
- `docs/code-map.md`
- `docs/maintenance-guide.md`
- `docs/task-sync-model.md`
