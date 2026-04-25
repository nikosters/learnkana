# LearnKana

Minimal Android app for drilling hiragana and katakana with strict Hepburn romaji answers.

## Local Setup

```bash
flutter pub get
```

## Local Checks

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

Do not run `flutter run` as part of post-implementation verification.
Do not run local `flutter build` as part of post-implementation verification; package builds run in CI.

## Branches

- `develop`: dev branch and nightly builds
- `main`: release branch

## Releases

Nightly builds publish from `develop` to the `nightly` prerelease.

Release builds publish from semver tags on `main`, for example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Android Release Secrets

Signed release builds require these GitHub Actions secrets:

```text
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
```
