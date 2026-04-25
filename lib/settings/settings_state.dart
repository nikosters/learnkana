class SettingsState {
  const SettingsState({
    required this.enabledEntryIds,
    required this.hiraganaEnabled,
    required this.katakanaEnabled,
    required this.yoonEnabled,
    required this.disabledEntryIds,
  });

  final Set<String> enabledEntryIds;
  final bool hiraganaEnabled;
  final bool katakanaEnabled;
  final bool yoonEnabled;
  final Set<String> disabledEntryIds;

  SettingsState copyWith({
    Set<String>? enabledEntryIds,
    bool? hiraganaEnabled,
    bool? katakanaEnabled,
    bool? yoonEnabled,
    Set<String>? disabledEntryIds,
  }) {
    return SettingsState(
      enabledEntryIds: enabledEntryIds ?? this.enabledEntryIds,
      hiraganaEnabled: hiraganaEnabled ?? this.hiraganaEnabled,
      katakanaEnabled: katakanaEnabled ?? this.katakanaEnabled,
      yoonEnabled: yoonEnabled ?? this.yoonEnabled,
      disabledEntryIds: disabledEntryIds ?? this.disabledEntryIds,
    );
  }
}

class SettingsSnapshot {
  const SettingsSnapshot({
    required this.hiraganaEnabled,
    required this.katakanaEnabled,
    required this.yoonEnabled,
    required this.disabledEntryIds,
  });

  final bool hiraganaEnabled;
  final bool katakanaEnabled;
  final bool yoonEnabled;
  final Set<String> disabledEntryIds;
}
