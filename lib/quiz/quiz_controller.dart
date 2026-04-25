import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/kana_entry.dart';
import '../data/kana_repository.dart';
import 'quiz_state.dart';

class QuizController extends ChangeNotifier {
  QuizController({required KanaRepository repository, Random? random})
    : _repository = repository,
      _random = random ?? Random();

  final KanaRepository _repository;
  final Random _random;
  QuizState? _state;

  QuizState get state {
    final state = _state;
    if (state == null) {
      throw StateError('Quiz entries have not been initialized.');
    }
    return state;
  }

  void updateEntries(Set<String> enabledEntryIds) {
    final entries = _repository.entriesForIds(enabledEntryIds);
    if (entries.isEmpty) {
      return;
    }

    final previous = _state?.currentEntry;
    final current = previous == null || !enabledEntryIds.contains(previous.id)
        ? _pickEntry(entries)
        : previous;

    _state = QuizState(
      currentEntry: current,
      input: _state?.input ?? '',
      enabledEntries: entries,
    );
    notifyListeners();
  }

  void updateInput(String value) {
    final state = this.state;
    _state = state.copyWith(input: value);
    notifyListeners();

    if (_normalize(value) == state.currentEntry.romaji) {
      _advance();
    }
  }

  void submit() {
    final state = this.state;
    if (_normalize(state.input) == state.currentEntry.romaji) {
      _advance();
    }
  }

  void _advance() {
    final state = this.state;
    _state = state.copyWith(
      currentEntry: _pickEntry(
        state.enabledEntries,
        previousEntry: state.currentEntry,
      ),
      input: '',
    );
    notifyListeners();
  }

  KanaEntry _pickEntry(List<KanaEntry> entries, {KanaEntry? previousEntry}) {
    if (entries.length == 1) {
      return entries.first;
    }

    KanaEntry next;
    do {
      next = entries[_random.nextInt(entries.length)];
    } while (next.id == previousEntry?.id);

    return next;
  }

  String _normalize(String value) => value.trim().toLowerCase();
}
