# Contributing

Thanks for your interest in improving LearnKana.

## Scope

LearnKana is intentionally small: a local Android app for drilling hiragana and katakana with strict Hepburn romaji answers. Changes should keep the app fast, offline, and simple.

## Local Setup

```bash
flutter pub get
```

## Checks

Run these before opening a pull request:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Do not include generated build outputs in commits.

## Pull Requests

- Keep changes focused.
- Include tests when behavior changes.
- Update documentation when setup, release, or user-visible behavior changes.
- Preserve the fully local nature of the app. Do not add analytics, telemetry, accounts, network services, or remote storage without opening an issue first.

## Issues

Bug reports should include:

- App version or commit.
- Android version and device/emulator details.
- Steps to reproduce.
- Expected behavior.
- Actual behavior.

Feature requests should describe the learning workflow they improve and why the change belongs in a minimal kana drill app.
