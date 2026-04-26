enum AppThemeMode { system, light, dark }

class SettingsState {
  const SettingsState({
    required this.enabledEntryIds,
    required this.hiraganaEnabled,
    required this.katakanaEnabled,
    required this.yoonEnabled,
    required this.disabledEntryIds,
    required this.themeMode,
  });

  final Set<String> enabledEntryIds;
  final bool hiraganaEnabled;
  final bool katakanaEnabled;
  final bool yoonEnabled;
  final Set<String> disabledEntryIds;
  final AppThemeMode themeMode;

  SettingsState copyWith({
    Set<String>? enabledEntryIds,
    bool? hiraganaEnabled,
    bool? katakanaEnabled,
    bool? yoonEnabled,
    Set<String>? disabledEntryIds,
    AppThemeMode? themeMode,
  }) {
    return SettingsState(
      enabledEntryIds: enabledEntryIds ?? this.enabledEntryIds,
      hiraganaEnabled: hiraganaEnabled ?? this.hiraganaEnabled,
      katakanaEnabled: katakanaEnabled ?? this.katakanaEnabled,
      yoonEnabled: yoonEnabled ?? this.yoonEnabled,
      disabledEntryIds: disabledEntryIds ?? this.disabledEntryIds,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsSnapshot {
  const SettingsSnapshot({
    required this.hiraganaEnabled,
    required this.katakanaEnabled,
    required this.yoonEnabled,
    required this.disabledEntryIds,
    required this.themeMode,
  });

  final bool hiraganaEnabled;
  final bool katakanaEnabled;
  final bool yoonEnabled;
  final Set<String> disabledEntryIds;
  final AppThemeMode themeMode;
}
