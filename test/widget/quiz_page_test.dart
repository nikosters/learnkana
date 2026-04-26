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
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
  });

  testWidgets('app defaults to system theme mode', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.themeMode, ThemeMode.system);
  });

  testWidgets('settings can switch app to dark theme mode', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();

    expect(find.text('Light'), findsOneWidget);
    expect(find.text('Dark'), findsOneWidget);

    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.themeMode, ThemeMode.dark);
  });

  testWidgets('tapping kana toggles romaji hint', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    final glyph = tester.widget<Text>(find.byKey(const Key('kanaGlyph')));
    const repository = KanaRepository();
    final entry = repository.allEntries.singleWhere(
      (entry) => entry.kana == glyph.data,
    );

    expect(find.text(entry.romaji), findsNothing);

    await tester.tap(find.byKey(const Key('kanaGlyph')));
    await tester.pump();

    expect(find.text(entry.romaji), findsOneWidget);

    await tester.tap(find.byKey(const Key('kanaGlyph')));
    await tester.pump();

    expect(find.text(entry.romaji), findsNothing);
  });

  testWidgets('romaji hint hides after advancing', (tester) async {
    await tester.pumpWidget(
      LearnKanaApp(settingsStorage: _MemorySettingsStorage()),
    );
    await tester.pumpAndSettle();

    final glyph = tester.widget<Text>(find.byKey(const Key('kanaGlyph')));
    const repository = KanaRepository();
    final entry = repository.allEntries.singleWhere(
      (entry) => entry.kana == glyph.data,
    );

    await tester.tap(find.byKey(const Key('kanaGlyph')));
    await tester.pump();
    expect(find.text(entry.romaji), findsOneWidget);

    await tester.enterText(find.byKey(const Key('romajiInput')), entry.romaji);
    await tester.pump();

    expect(find.text(entry.romaji), findsNothing);
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
