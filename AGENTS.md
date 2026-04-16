# AGENTS.md

## Scope

These instructions apply to the whole `scatesdk_flutter` repository.

## Project purpose

This is the Flutter plugin wrapper for the Scate SDK. It exposes Dart APIs and bridges to native Android and iOS SDK implementations.

## Important areas

- `lib/`: Dart API, platform interface, and method-channel implementation
- `android/`: Android plugin implementation and Gradle configuration
- `ios/`: iOS plugin implementation and podspec
- `example/`: sample Flutter app
- `pubspec.yaml`: plugin metadata, version, and dependencies
- `CHANGELOG.md`: package release history

## Working guidance

- Keep Dart API changes aligned with both native platform implementations.
- Preserve backward compatibility for public APIs unless a versioned breaking change is intentional.
- When changing package version in `pubspec.yaml`, update `CHANGELOG.md`.
- Keep README examples aligned with the actual Dart API.
- Avoid committing generated Flutter build output or local platform artifacts.
- Keep native SDK dependency versions aligned with the published Scate iOS/Android SDK versions.

## Validation

From the repo root:

```bash
flutter pub get
flutter analyze
flutter test
```

For plugin changes, also run the example app on at least one platform when practical.
