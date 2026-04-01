# maintenance guide

## Goal

This guide is for bug fixes and small refactorings in the current codebase.

## General rules

- Make the smallest change that fixes the issue.
- Check provider, controller, and service responsibilities before moving code.
- Do not hand-edit generated files.
- Use existing logger utilities for new diagnostics.

## If a bug is in task save or sync

Start here:

1. `lib/providers/task_provider.dart`
2. `lib/services/common_task_service.dart`
3. `lib/services/local_task_service.dart`
4. `lib/services/remote_task_service.dart`
5. `lib/controllers/sync_controller.dart`

Typical questions:

- Did local state update?
- Was JSON cache saved?
- Was remote write attempted?
- Can the failure be retried later?

## If a bug is in timer completion or delayed updates

Start here:

1. `lib/controllers/timer_controller.dart`
2. `lib/controllers/ticking_timer.dart`
3. `lib/providers/pomodoro_summary_provider.dart`
4. `lib/providers/task_provider.dart`

Typical questions:

- Is the timer writing partial progress?
- Is the final session write racing with manual edits?
- Is remote persistence blocking too long?

## If a bug is in auth or Google access

Start here:

1. `lib/controllers/auth_controller.dart`
2. `lib/services/auth/`
3. `lib/services/remote_task_service.dart`

## If a bug is in startup or env-dependent behavior

Start here:

1. `lib/utils/env_config.dart`
2. `lib/utils/app_startup_initializer.dart`
3. `lib/main.dart`

## Recommended small refactors

- remove duplicate branching in service selection
- clarify local/remote write responsibilities
- add focused logging around high-risk async paths
- reduce controller methods that mix UI and persistence concerns
