# Baseline Pulse

Baseline Pulse is a tactical hybrid performance platform focused on run + ruck execution, with ruck treated as a wedge discipline.

The app is scaffolded for a clean feature-based architecture, an intelligence layer, offline-first local storage, and future cloud sync.

## Architecture Map

- `lib/src/bootstrap`: crash-safe startup and app initialization
- `lib/src/app`: app shell, router, global theming
- `lib/src/core`: shared primitives (errors, logging, models, utils)
- `lib/src/features/*`: feature slices (`data`, `domain`, `presentation`)
- `lib/src/services`: integration services (reserved)

Initial modules:
- `home`
- `run`
- `ruck`
- `sessions`
- `auth`

Roadmap-ready placeholders:
- offline-first persistence via Hive
- Firebase sync integration (no keys/config committed)
- RevenueCat integration later

## Run

```bash
flutter pub get
flutter run
```

## Test

```bash
flutter analyze
flutter test
```
