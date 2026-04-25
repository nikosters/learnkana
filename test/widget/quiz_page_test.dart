import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learnkana/data/kana_repository.dart';
import 'package:learnkana/quiz/quiz_controller.dart';
import 'package:learnkana/settings/settings_controller.dart';
import 'package:learnkana/storage/settings_storage.dart';

import 'package:learnkana/app.dart';
import 'package:learnkana/settings/settings_state.dart';

void main() {
  testWidgets('quiz screen renders kana and accepts input', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('kanaGlyph')), findsOneWidget);
    expect(find.byKey(const Key('romajiInput')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('romajiInput')), 'x');
    expect(find.text('x'), findsOneWidget);
  });

  testWidgets('settings button opens settings', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Hiragana'), findsOneWidget);
    expect(find.text('Katakana'), findsOneWidget);
    expect(find.text('Combinations'), findsOneWidget);
  });

  testWidgets('settings toggles affect available quiz entries', (tester) async {
    const repository = KanaRepository();
    final settingsController = SettingsController(
      repository: repository,
      storage: _MemorySettingsStorage(),
    );
    await settingsController.load();
    final quizController = QuizController(repository: repository);
    quizController.updateEntries(settingsController.state.enabledEntryIds);
    settingsController.addListener(() {
      quizController.updateEntries(settingsController.state.enabledEntryIds);
    });

    await settingsController.setKatakanaEnabled(false);

    expect(
      quizController.state.enabledEntries.every(
        (entry) => entry.id.startsWith('hiragana.'),
      ),
      isTrue,
    );
  });
}

class _MemorySettingsStorage implements SettingsStorage {
  SettingsSnapshot? snapshot;

  @override
  Future<SettingsSnapshot?> read() async => snapshot;

  @override
  Future<void> write(SettingsSnapshot snapshot) async {
    this.snapshot = snapshot;
  }
}
