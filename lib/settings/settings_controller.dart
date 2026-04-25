import 'package:flutter/foundation.dart';

import '../data/kana_entry.dart';
import '../data/kana_repository.dart';
import '../storage/settings_storage.dart';
import 'settings_state.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({
    required KanaRepository repository,
    required SettingsStorage storage,
  }) : _repository = repository,
       _storage = storage,
       _state = _defaultState(repository);

  final KanaRepository _repository;
  final SettingsStorage _storage;
  SettingsState _state;

  SettingsState get state => _state;

  Future<void> load() async {
    final snapshot = await _storage.read();
    if (snapshot == null) {
      _state = _defaultState(_repository);
      return;
    }

    _state = _stateFromSnapshot(snapshot);
    if (_state.enabledEntryIds.isEmpty) {
      _state = _defaultState(_repository);
      await _save();
    }
  }

  Future<void> setHiraganaEnabled(bool enabled) async {
    await _apply(
      hiraganaEnabled: enabled,
      katakanaEnabled: _state.katakanaEnabled,
      yoonEnabled: _state.yoonEnabled,
      disabledEntryIds: _state.disabledEntryIds,
    );
  }

  Future<void> setKatakanaEnabled(bool enabled) async {
    await _apply(
      hiraganaEnabled: _state.hiraganaEnabled,
      katakanaEnabled: enabled,
      yoonEnabled: _state.yoonEnabled,
      disabledEntryIds: _state.disabledEntryIds,
    );
  }

  Future<void> setYoonEnabled(bool enabled) async {
    await _apply(
      hiraganaEnabled: _state.hiraganaEnabled,
      katakanaEnabled: _state.katakanaEnabled,
      yoonEnabled: enabled,
      disabledEntryIds: _state.disabledEntryIds,
    );
  }

  Future<void> setEntryEnabled(KanaEntry entry, bool enabled) async {
    final disabledEntryIds = Set<String>.from(_state.disabledEntryIds);
    if (enabled) {
      disabledEntryIds.remove(entry.id);
    } else {
      disabledEntryIds.add(entry.id);
    }

    await _apply(
      hiraganaEnabled: _state.hiraganaEnabled,
      katakanaEnabled: _state.katakanaEnabled,
      yoonEnabled: _state.yoonEnabled,
      disabledEntryIds: disabledEntryIds,
    );
  }

  bool isEntryEnabled(KanaEntry entry) {
    return _state.enabledEntryIds.contains(entry.id);
  }

  Future<void> _apply({
    required bool hiraganaEnabled,
    required bool katakanaEnabled,
    required bool yoonEnabled,
    required Set<String> disabledEntryIds,
  }) async {
    final enabledEntryIds = _repository.enabledEntryIds(
      hiraganaEnabled: hiraganaEnabled,
      katakanaEnabled: katakanaEnabled,
      yoonEnabled: yoonEnabled,
      disabledEntryIds: disabledEntryIds,
    );

    if (enabledEntryIds.isEmpty) {
      return;
    }

    _state = SettingsState(
      enabledEntryIds: enabledEntryIds,
      hiraganaEnabled: hiraganaEnabled,
      katakanaEnabled: katakanaEnabled,
      yoonEnabled: yoonEnabled,
      disabledEntryIds: disabledEntryIds,
    );
    notifyListeners();
    await _save();
  }

  Future<void> _save() {
    return _storage.write(
      SettingsSnapshot(
        hiraganaEnabled: _state.hiraganaEnabled,
        katakanaEnabled: _state.katakanaEnabled,
        yoonEnabled: _state.yoonEnabled,
        disabledEntryIds: _state.disabledEntryIds,
      ),
    );
  }

  SettingsState _stateFromSnapshot(SettingsSnapshot snapshot) {
    final enabledEntryIds = _repository.enabledEntryIds(
      hiraganaEnabled: snapshot.hiraganaEnabled,
      katakanaEnabled: snapshot.katakanaEnabled,
      yoonEnabled: snapshot.yoonEnabled,
      disabledEntryIds: snapshot.disabledEntryIds,
    );

    return SettingsState(
      enabledEntryIds: enabledEntryIds,
      hiraganaEnabled: snapshot.hiraganaEnabled,
      katakanaEnabled: snapshot.katakanaEnabled,
      yoonEnabled: snapshot.yoonEnabled,
      disabledEntryIds: snapshot.disabledEntryIds,
    );
  }

  static SettingsState _defaultState(KanaRepository repository) {
    final enabledEntryIds = repository.enabledEntryIds(
      hiraganaEnabled: true,
      katakanaEnabled: true,
      yoonEnabled: false,
      disabledEntryIds: {},
    );

    return SettingsState(
      enabledEntryIds: enabledEntryIds,
      hiraganaEnabled: true,
      katakanaEnabled: true,
      yoonEnabled: false,
      disabledEntryIds: const {},
    );
  }
}
