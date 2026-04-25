import 'package:flutter_test/flutter_test.dart';
import 'package:learnkana/data/kana_entry.dart';
import 'package:learnkana/data/kana_repository.dart';

void main() {
  const repository = KanaRepository();

  test('contains hiragana and katakana base entries', () {
    expect(_romajiFor('あ'), 'a');
    expect(_romajiFor('ア'), 'a');
    expect(_romajiFor('ん'), 'n');
    expect(_romajiFor('ン'), 'n');
  });

  test('uses strict Hepburn mappings', () {
    expect(_romajiFor('し'), 'shi');
    expect(_romajiFor('シ'), 'shi');
    expect(_romajiFor('ち'), 'chi');
    expect(_romajiFor('チ'), 'chi');
    expect(_romajiFor('つ'), 'tsu');
    expect(_romajiFor('ツ'), 'tsu');
    expect(_romajiFor('ふ'), 'fu');
    expect(_romajiFor('フ'), 'fu');
    expect(_romajiFor('を'), 'wo');
    expect(_romajiFor('ヲ'), 'wo');
    expect(_romajiFor('ぢ'), 'ji');
    expect(_romajiFor('ヂ'), 'ji');
    expect(_romajiFor('づ'), 'zu');
    expect(_romajiFor('ヅ'), 'zu');
  });

  test('contains yoon entries', () {
    final hiragana = repository.allEntries.singleWhere(
      (entry) => entry.kana == 'にゃ',
    );
    final katakana = repository.allEntries.singleWhere(
      (entry) => entry.kana == 'ニャ',
    );

    expect(hiragana.romaji, 'nya');
    expect(hiragana.group, KanaGroup.yoon);
    expect(katakana.romaji, 'nya');
    expect(katakana.group, KanaGroup.yoon);
  });

  test('uses unique IDs', () {
    final ids = repository.allEntries.map((entry) => entry.id).toList();

    expect(ids.toSet(), hasLength(ids.length));
  });
}

String _romajiFor(String kana) {
  return const KanaRepository().allEntries
      .singleWhere((entry) => entry.kana == kana)
      .romaji;
}
