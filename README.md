# LearnKana

LearnKana is a minimal Android app for drilling hiragana and katakana by typing strict Hepburn romaji answers.

## Privacy

LearnKana is fully local.

- It does not require an account.
- It does not send analytics, telemetry, crash reports, or study data.
- It does not use a remote backend.
- Settings and practice preferences are stored on the device.

## Features

- Hiragana and katakana drills.
- Strict Hepburn romaji answers.
- Optional kana combinations.
- Per-kana enable and disable controls.
- Lightweight offline-first Flutter UI.

## Requirements

- Flutter stable.
- Android toolchain configured for Flutter.

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

- `develop`: development branch and nightly builds.
- `main`: release branch.

## Releases

Nightly builds publish from `develop` to the `nightly` prerelease.

Release builds publish from semver tags on `main`, for example:

```bash
git tag v1.0.0
git push origin v1.0.0
```

Signed release builds require these GitHub Actions secrets:

```text
ANDROID_KEYSTORE_BASE64
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_ALIAS
ANDROID_KEY_PASSWORD
```

## Contributing

Contributions are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for setup, checks, and pull request expectations.

## Security

Please report security issues privately. See [SECURITY.md](SECURITY.md).

## License

LearnKana is licensed under the [MIT License](LICENSE).
