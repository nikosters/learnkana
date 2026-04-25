import '../data/kana_entry.dart';

class QuizState {
  const QuizState({
    required this.currentEntry,
    required this.input,
    required this.enabledEntries,
  });

  final KanaEntry currentEntry;
  final String input;
  final List<KanaEntry> enabledEntries;

  QuizState copyWith({
    KanaEntry? currentEntry,
    String? input,
    List<KanaEntry>? enabledEntries,
  }) {
    return QuizState(
      currentEntry: currentEntry ?? this.currentEntry,
      input: input ?? this.input,
      enabledEntries: enabledEntries ?? this.enabledEntries,
    );
  }
}
