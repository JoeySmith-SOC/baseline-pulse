# BASELINE PULSE

Production-grade tactical run + ruck tracker with offline-first storage, maps, and Firebase sync scaffolding.

## Stack
- Flutter (stable)
- Hive local persistence
- Firebase Core/Auth/Firestore
- Geolocator + Google Maps
- Health Connect scaffold via `health`
- RevenueCat scaffold via `purchases_flutter`

## Setup
1. Install Flutter stable and Android SDK.
2. Create Firebase project and Android app package `com.baselinepulse.baseline_pulse`.
3. Place `android/app/google-services.json` locally (do not commit).
4. Generate Firebase options:
   - `dart pub global activate flutterfire_cli`
   - `flutterfire configure --project=YOUR_PROJECT_ID --platforms=android,ios`
5. Configure Maps key in `android/local.properties`:
   - `MAPS_API_KEY=YOUR_MAPS_KEY`
6. (Optional) RevenueCat: wire `Purchases.configure` inside `subscription_service.dart`.
7. Install deps and run:
   - `flutter pub get`
   - `flutter run -d emulator-5554`

## Security Notes
- No API keys are committed in source.
- `google-services.json`, `local.properties`, and keystore files are gitignored.
- Logging is suppressed in release paths.
- Firebase bootstrap fails gracefully and app still works in local/offline mode.

## Firebase Security Rules
Use `firestore.rules` included in repo:
- `users/{uid}/runs/{sessionId}` restricted to `request.auth.uid == uid`
- `users/{uid}/rucks/{sessionId}` restricted to `request.auth.uid == uid`
- deny all else

## Architecture
Feature-based structure with service-driven business logic.
- UI in `features/*/screens` and `features/*/widgets`
- Business logic in `features/*/services`
- Models in `features/*/models`
- Bootstrap and app shell in `app/` + `core/bootstrap`

## Acceptance Checklist
- [ ] App launches to Home with Run/Ruck/Workouts/Recovery tiles.
- [ ] Run flow works: setup -> active -> summary -> history.
- [ ] Ruck flow works: setup (weight required) -> active -> summary -> history.
- [ ] Locale unit default works (US=mi, else km), manual override works.
- [ ] GPS route polyline renders on map when permission granted.
- [ ] Time mode can run without GPS.
- [ ] Distance/Open modes warn before no-GPS start.
- [ ] Splits auto-record every 1 mi/km.
- [ ] Sessions persist in Hive and list newest-first in history screens.
- [ ] Firebase anonymous auth initializes when configured.
- [ ] Sync queue enqueues on finish and retries via flush.
- [ ] Recovery screen shows Health Connect status scaffold.
- [ ] Premium-gated action opens paywall for free tier.

## firebase_options.dart policy
This repository currently keeps a placeholder `lib/firebase_options.dart` for compile safety.
If your team prefers generated-only per developer, keep it gitignored and regenerate locally with `flutterfire configure`.
