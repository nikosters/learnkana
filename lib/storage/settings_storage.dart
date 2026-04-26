import 'package:shared_preferences/shared_preferences.dart';

import '../settings/settings_state.dart';

abstract class SettingsStorage {
  Future<SettingsSnapshot?> read();

  Future<void> write(SettingsSnapshot snapshot);
}

class SharedPreferencesSettingsStorage implements SettingsStorage {
  static const _hiraganaEnabledKey = 'settings.hiraganaEnabled';
  static const _katakanaEnabledKey = 'settings.katakanaEnabled';
  static const _yoonEnabledKey = 'settings.yoonEnabled';
  static const _disabledEntryIdsKey = 'settings.disabledEntryIds';
  static const _themeModeKey = 'settings.themeMode';

  @override
  Future<SettingsSnapshot?> read() async {
    final preferences = await SharedPreferences.getInstance();

    final hasAnySetting =
        preferences.containsKey(_hiraganaEnabledKey) ||
        preferences.containsKey(_katakanaEnabledKey) ||
        preferences.containsKey(_yoonEnabledKey) ||
        preferences.containsKey(_disabledEntryIdsKey) ||
        preferences.containsKey(_themeModeKey);

    if (!hasAnySetting) {
      return null;
    }

    return SettingsSnapshot(
      hiraganaEnabled: preferences.getBool(_hiraganaEnabledKey) ?? true,
      katakanaEnabled: preferences.getBool(_katakanaEnabledKey) ?? true,
      yoonEnabled: preferences.getBool(_yoonEnabledKey) ?? false,
      disabledEntryIds:
          preferences.getStringList(_disabledEntryIdsKey)?.toSet() ?? {},
      themeMode: _themeModeFromString(preferences.getString(_themeModeKey)),
    );
  }

  @override
  Future<void> write(SettingsSnapshot snapshot) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_hiraganaEnabledKey, snapshot.hiraganaEnabled);
    await preferences.setBool(_katakanaEnabledKey, snapshot.katakanaEnabled);
    await preferences.setBool(_yoonEnabledKey, snapshot.yoonEnabled);
    await preferences.setStringList(
      _disabledEntryIdsKey,
      snapshot.disabledEntryIds.toList()..sort(),
    );
    await preferences.setString(_themeModeKey, snapshot.themeMode.name);
  }

  AppThemeMode _themeModeFromString(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}
