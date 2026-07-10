import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:learnkana/data/kana_repository.dart';
import 'package:learnkana/quiz/quiz_controller.dart';

void main() {
  const repository = KanaRepository();

  test('correct answer advances and clears input', () {
    final controller = QuizController(
      repository: repository,
      random: Random(1),
    );
    controller.updateEntries({'hiragana.basic.a', 'hiragana.basic.i'});
    final first = controller.state.currentEntry;

    controller.updateInput(' ${first.romaji.toUpperCase()} ');

    expect(controller.state.input, isEmpty);
    expect(controller.state.currentEntry.id, isNot(first.id));
  });

  test('incorrect answer does not advance', () {
    final controller = QuizController(repository: repository);
    controller.updateEntries({'hiragana.basic.a', 'hiragana.basic.i'});
    final first = controller.state.currentEntry;

    controller.updateInput('x');

    expect(controller.state.input, 'x');
    expect(controller.state.currentEntry.id, first.id);
  });

  test('single enabled entry can repeat', () {
    final controller = QuizController(repository: repository);
    controller.updateEntries({'hiragana.basic.a'});

    controller.updateInput('a');

    expect(controller.state.input, isEmpty);
    expect(controller.state.currentEntry.id, 'hiragana.basic.a');
  });

  test('changing the current entry through settings clears stale input', () {
    final controller = QuizController(
      repository: repository,
      random: Random(1),
    );
    controller.updateEntries({'hiragana.basic.a', 'hiragana.basic.i'});
    final currentId = controller.state.currentEntry.id;
    final remainingId = currentId == 'hiragana.basic.a'
        ? 'hiragana.basic.i'
        : 'hiragana.basic.a';
    controller.updateInput('partial');

    controller.updateEntries({remainingId});

    expect(controller.state.currentEntry.id, remainingId);
    expect(controller.state.input, isEmpty);
  });
}
