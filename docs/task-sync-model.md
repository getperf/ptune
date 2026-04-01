# task sync model

## Purpose

ptune manages task data through both local and remote layers.

This exists for two reasons:

- the app must continue working when remote updates fail
- timer-related updates should not block the UI on every remote request

## Main components

- `lib/providers/task_provider.dart`
- `lib/services/common_task_service.dart`
- `lib/services/local_task_service.dart`
- `lib/services/remote_task_service.dart`
- `lib/controllers/sync_controller.dart`
- `lib/controllers/timer_controller.dart`

## Data model

### Local

Local task state is stored in:

- in-memory provider state
- JSON file persistence via `LocalTaskService`

Local is the fast path used by the UI.

### Remote

Remote task state is stored in Google Tasks and accessed through
`RemoteTaskService`.

Remote is slower and may fail because of:

- connectivity problems
- auth expiration
- Google API errors

## Normal update flow

Typical task updates should be understood as:

1. update local/UI-visible state first
2. persist to local cache
3. send remote update
4. reconcile later if remote update fails

This means the app behaves as eventually consistent, not strictly synchronous.

## Offline or remote failure behavior

When remote updates fail:

- local state may still be ahead of remote
- the app can continue using cached local tasks
- later sync or export/import style flows may push local changes outward

## Timer-specific behavior

Timer processing can apply intermediate and final task updates.

Because waiting on every remote request would hurt responsiveness:

- part of the update flow may be deferred
- remote persistence may happen asynchronously

This improves UX, but increases the chance of:

- stale local vs remote divergence
- duplicated saves
- ordering problems between manual edits and timer-generated updates

## Common failure modes

- local updated but remote not updated
- remote write succeeds after a newer local edit already exists
- timer-generated partial commit overlaps with manual task editing
- later sync pushes stale local state back to remote
- cache file and in-memory state drift after exceptions

## Files to inspect first

When local/remote inconsistency is reported, inspect in this order:

1. `providers/task_provider.dart`
2. `services/common_task_service.dart`
3. `services/local_task_service.dart`
4. `services/remote_task_service.dart`
5. `controllers/sync_controller.dart`
6. `controllers/timer_controller.dart`

## Maintenance guidance

- Avoid adding new write paths unless necessary.
- Prefer one clear update path for task mutation.
- Be explicit about whether a change is local-only, remote-only, or both.
- When changing timer behavior, review task commit timing carefully.
