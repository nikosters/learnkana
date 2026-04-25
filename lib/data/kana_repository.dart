import 'kana_entry.dart';

class KanaRepository {
  const KanaRepository();

  List<KanaEntry> get allEntries => _entries;

  List<KanaEntry> entriesForIds(Set<String> ids) {
    return _entries.where((entry) => ids.contains(entry.id)).toList();
  }

  Set<String> enabledEntryIds({
    required bool hiraganaEnabled,
    required bool katakanaEnabled,
    required bool yoonEnabled,
    required Set<String> disabledEntryIds,
  }) {
    return _entries
        .where((entry) {
          final scriptEnabled = switch (entry.script) {
            KanaScript.hiragana => hiraganaEnabled,
            KanaScript.katakana => katakanaEnabled,
          };
          final groupEnabled = yoonEnabled || entry.group != KanaGroup.yoon;

          return scriptEnabled &&
              groupEnabled &&
              !disabledEntryIds.contains(entry.id);
        })
        .map((entry) => entry.id)
        .toSet();
  }
}

List<KanaEntry> get _entries {
  final entries = <KanaEntry>[];

  for (final source in _hiraganaSources) {
    entries.add(source.entry(KanaScript.hiragana));
  }
  for (final source in _katakanaSources) {
    entries.add(source.entry(KanaScript.katakana));
  }

  return List.unmodifiable(entries);
}

class _KanaSource {
  const _KanaSource(this.group, this.kana, this.romaji, {String? idSuffix})
    : idSuffix = idSuffix ?? romaji;

  final KanaGroup group;
  final String kana;
  final String romaji;
  final String idSuffix;

  KanaEntry entry(KanaScript script) {
    final scriptName = script.name;
    return KanaEntry(
      id: '$scriptName.${group.name}.$idSuffix',
      script: script,
      group: group,
      kana: kana,
      romaji: romaji,
    );
  }
}

const _hiraganaSources = <_KanaSource>[
  _KanaSource(KanaGroup.basic, 'あ', 'a'),
  _KanaSource(KanaGroup.basic, 'い', 'i'),
  _KanaSource(KanaGroup.basic, 'う', 'u'),
  _KanaSource(KanaGroup.basic, 'え', 'e'),
  _KanaSource(KanaGroup.basic, 'お', 'o'),
  _KanaSource(KanaGroup.basic, 'か', 'ka'),
  _KanaSource(KanaGroup.basic, 'き', 'ki'),
  _KanaSource(KanaGroup.basic, 'く', 'ku'),
  _KanaSource(KanaGroup.basic, 'け', 'ke'),
  _KanaSource(KanaGroup.basic, 'こ', 'ko'),
  _KanaSource(KanaGroup.basic, 'さ', 'sa'),
  _KanaSource(KanaGroup.basic, 'し', 'shi'),
  _KanaSource(KanaGroup.basic, 'す', 'su'),
  _KanaSource(KanaGroup.basic, 'せ', 'se'),
  _KanaSource(KanaGroup.basic, 'そ', 'so'),
  _KanaSource(KanaGroup.basic, 'た', 'ta'),
  _KanaSource(KanaGroup.basic, 'ち', 'chi'),
  _KanaSource(KanaGroup.basic, 'つ', 'tsu'),
  _KanaSource(KanaGroup.basic, 'て', 'te'),
  _KanaSource(KanaGroup.basic, 'と', 'to'),
  _KanaSource(KanaGroup.basic, 'な', 'na'),
  _KanaSource(KanaGroup.basic, 'に', 'ni'),
  _KanaSource(KanaGroup.basic, 'ぬ', 'nu'),
  _KanaSource(KanaGroup.basic, 'ね', 'ne'),
  _KanaSource(KanaGroup.basic, 'の', 'no'),
  _KanaSource(KanaGroup.basic, 'は', 'ha'),
  _KanaSource(KanaGroup.basic, 'ひ', 'hi'),
  _KanaSource(KanaGroup.basic, 'ふ', 'fu'),
  _KanaSource(KanaGroup.basic, 'へ', 'he'),
  _KanaSource(KanaGroup.basic, 'ほ', 'ho'),
  _KanaSource(KanaGroup.basic, 'ま', 'ma'),
  _KanaSource(KanaGroup.basic, 'み', 'mi'),
  _KanaSource(KanaGroup.basic, 'む', 'mu'),
  _KanaSource(KanaGroup.basic, 'め', 'me'),
  _KanaSource(KanaGroup.basic, 'も', 'mo'),
  _KanaSource(KanaGroup.basic, 'や', 'ya'),
  _KanaSource(KanaGroup.basic, 'ゆ', 'yu'),
  _KanaSource(KanaGroup.basic, 'よ', 'yo'),
  _KanaSource(KanaGroup.basic, 'ら', 'ra'),
  _KanaSource(KanaGroup.basic, 'り', 'ri'),
  _KanaSource(KanaGroup.basic, 'る', 'ru'),
  _KanaSource(KanaGroup.basic, 'れ', 're'),
  _KanaSource(KanaGroup.basic, 'ろ', 'ro'),
  _KanaSource(KanaGroup.basic, 'わ', 'wa'),
  _KanaSource(KanaGroup.basic, 'を', 'wo'),
  _KanaSource(KanaGroup.basic, 'ん', 'n'),
  _KanaSource(KanaGroup.dakuten, 'が', 'ga'),
  _KanaSource(KanaGroup.dakuten, 'ぎ', 'gi'),
  _KanaSource(KanaGroup.dakuten, 'ぐ', 'gu'),
  _KanaSource(KanaGroup.dakuten, 'げ', 'ge'),
  _KanaSource(KanaGroup.dakuten, 'ご', 'go'),
  _KanaSource(KanaGroup.dakuten, 'ざ', 'za'),
  _KanaSource(KanaGroup.dakuten, 'じ', 'ji'),
  _KanaSource(KanaGroup.dakuten, 'ず', 'zu'),
  _KanaSource(KanaGroup.dakuten, 'ぜ', 'ze'),
  _KanaSource(KanaGroup.dakuten, 'ぞ', 'zo'),
  _KanaSource(KanaGroup.dakuten, 'だ', 'da'),
  _KanaSource(KanaGroup.dakuten, 'ぢ', 'ji', idSuffix: 'di'),
  _KanaSource(KanaGroup.dakuten, 'づ', 'zu', idSuffix: 'du'),
  _KanaSource(KanaGroup.dakuten, 'で', 'de'),
  _KanaSource(KanaGroup.dakuten, 'ど', 'do'),
  _KanaSource(KanaGroup.dakuten, 'ば', 'ba'),
  _KanaSource(KanaGroup.dakuten, 'び', 'bi'),
  _KanaSource(KanaGroup.dakuten, 'ぶ', 'bu'),
  _KanaSource(KanaGroup.dakuten, 'べ', 'be'),
  _KanaSource(KanaGroup.dakuten, 'ぼ', 'bo'),
  _KanaSource(KanaGroup.handakuten, 'ぱ', 'pa'),
  _KanaSource(KanaGroup.handakuten, 'ぴ', 'pi'),
  _KanaSource(KanaGroup.handakuten, 'ぷ', 'pu'),
  _KanaSource(KanaGroup.handakuten, 'ぺ', 'pe'),
  _KanaSource(KanaGroup.handakuten, 'ぽ', 'po'),
  _KanaSource(KanaGroup.yoon, 'きゃ', 'kya'),
  _KanaSource(KanaGroup.yoon, 'きゅ', 'kyu'),
  _KanaSource(KanaGroup.yoon, 'きょ', 'kyo'),
  _KanaSource(KanaGroup.yoon, 'しゃ', 'sha'),
  _KanaSource(KanaGroup.yoon, 'しゅ', 'shu'),
  _KanaSource(KanaGroup.yoon, 'しょ', 'sho'),
  _KanaSource(KanaGroup.yoon, 'ちゃ', 'cha'),
  _KanaSource(KanaGroup.yoon, 'ちゅ', 'chu'),
  _KanaSource(KanaGroup.yoon, 'ちょ', 'cho'),
  _KanaSource(KanaGroup.yoon, 'にゃ', 'nya'),
  _KanaSource(KanaGroup.yoon, 'にゅ', 'nyu'),
  _KanaSource(KanaGroup.yoon, 'にょ', 'nyo'),
  _KanaSource(KanaGroup.yoon, 'ひゃ', 'hya'),
  _KanaSource(KanaGroup.yoon, 'ひゅ', 'hyu'),
  _KanaSource(KanaGroup.yoon, 'ひょ', 'hyo'),
  _KanaSource(KanaGroup.yoon, 'みゃ', 'mya'),
  _KanaSource(KanaGroup.yoon, 'みゅ', 'myu'),
  _KanaSource(KanaGroup.yoon, 'みょ', 'myo'),
  _KanaSource(KanaGroup.yoon, 'りゃ', 'rya'),
  _KanaSource(KanaGroup.yoon, 'りゅ', 'ryu'),
  _KanaSource(KanaGroup.yoon, 'りょ', 'ryo'),
  _KanaSource(KanaGroup.yoon, 'ぎゃ', 'gya'),
  _KanaSource(KanaGroup.yoon, 'ぎゅ', 'gyu'),
  _KanaSource(KanaGroup.yoon, 'ぎょ', 'gyo'),
  _KanaSource(KanaGroup.yoon, 'じゃ', 'ja'),
  _KanaSource(KanaGroup.yoon, 'じゅ', 'ju'),
  _KanaSource(KanaGroup.yoon, 'じょ', 'jo'),
  _KanaSource(KanaGroup.yoon, 'びゃ', 'bya'),
  _KanaSource(KanaGroup.yoon, 'びゅ', 'byu'),
  _KanaSource(KanaGroup.yoon, 'びょ', 'byo'),
  _KanaSource(KanaGroup.yoon, 'ぴゃ', 'pya'),
  _KanaSource(KanaGroup.yoon, 'ぴゅ', 'pyu'),
  _KanaSource(KanaGroup.yoon, 'ぴょ', 'pyo'),
];

const _katakanaSources = <_KanaSource>[
  _KanaSource(KanaGroup.basic, 'ア', 'a'),
  _KanaSource(KanaGroup.basic, 'イ', 'i'),
  _KanaSource(KanaGroup.basic, 'ウ', 'u'),
  _KanaSource(KanaGroup.basic, 'エ', 'e'),
  _KanaSource(KanaGroup.basic, 'オ', 'o'),
  _KanaSource(KanaGroup.basic, 'カ', 'ka'),
  _KanaSource(KanaGroup.basic, 'キ', 'ki'),
  _KanaSource(KanaGroup.basic, 'ク', 'ku'),
  _KanaSource(KanaGroup.basic, 'ケ', 'ke'),
  _KanaSource(KanaGroup.basic, 'コ', 'ko'),
  _KanaSource(KanaGroup.basic, 'サ', 'sa'),
  _KanaSource(KanaGroup.basic, 'シ', 'shi'),
  _KanaSource(KanaGroup.basic, 'ス', 'su'),
  _KanaSource(KanaGroup.basic, 'セ', 'se'),
  _KanaSource(KanaGroup.basic, 'ソ', 'so'),
  _KanaSource(KanaGroup.basic, 'タ', 'ta'),
  _KanaSource(KanaGroup.basic, 'チ', 'chi'),
  _KanaSource(KanaGroup.basic, 'ツ', 'tsu'),
  _KanaSource(KanaGroup.basic, 'テ', 'te'),
  _KanaSource(KanaGroup.basic, 'ト', 'to'),
  _KanaSource(KanaGroup.basic, 'ナ', 'na'),
  _KanaSource(KanaGroup.basic, 'ニ', 'ni'),
  _KanaSource(KanaGroup.basic, 'ヌ', 'nu'),
  _KanaSource(KanaGroup.basic, 'ネ', 'ne'),
  _KanaSource(KanaGroup.basic, 'ノ', 'no'),
  _KanaSource(KanaGroup.basic, 'ハ', 'ha'),
  _KanaSource(KanaGroup.basic, 'ヒ', 'hi'),
  _KanaSource(KanaGroup.basic, 'フ', 'fu'),
  _KanaSource(KanaGroup.basic, 'ヘ', 'he'),
  _KanaSource(KanaGroup.basic, 'ホ', 'ho'),
  _KanaSource(KanaGroup.basic, 'マ', 'ma'),
  _KanaSource(KanaGroup.basic, 'ミ', 'mi'),
  _KanaSource(KanaGroup.basic, 'ム', 'mu'),
  _KanaSource(KanaGroup.basic, 'メ', 'me'),
  _KanaSource(KanaGroup.basic, 'モ', 'mo'),
  _KanaSource(KanaGroup.basic, 'ヤ', 'ya'),
  _KanaSource(KanaGroup.basic, 'ユ', 'yu'),
  _KanaSource(KanaGroup.basic, 'ヨ', 'yo'),
  _KanaSource(KanaGroup.basic, 'ラ', 'ra'),
  _KanaSource(KanaGroup.basic, 'リ', 'ri'),
  _KanaSource(KanaGroup.basic, 'ル', 'ru'),
  _KanaSource(KanaGroup.basic, 'レ', 're'),
  _KanaSource(KanaGroup.basic, 'ロ', 'ro'),
  _KanaSource(KanaGroup.basic, 'ワ', 'wa'),
  _KanaSource(KanaGroup.basic, 'ヲ', 'wo'),
  _KanaSource(KanaGroup.basic, 'ン', 'n'),
  _KanaSource(KanaGroup.dakuten, 'ガ', 'ga'),
  _KanaSource(KanaGroup.dakuten, 'ギ', 'gi'),
  _KanaSource(KanaGroup.dakuten, 'グ', 'gu'),
  _KanaSource(KanaGroup.dakuten, 'ゲ', 'ge'),
  _KanaSource(KanaGroup.dakuten, 'ゴ', 'go'),
  _KanaSource(KanaGroup.dakuten, 'ザ', 'za'),
  _KanaSource(KanaGroup.dakuten, 'ジ', 'ji'),
  _KanaSource(KanaGroup.dakuten, 'ズ', 'zu'),
  _KanaSource(KanaGroup.dakuten, 'ゼ', 'ze'),
  _KanaSource(KanaGroup.dakuten, 'ゾ', 'zo'),
  _KanaSource(KanaGroup.dakuten, 'ダ', 'da'),
  _KanaSource(KanaGroup.dakuten, 'ヂ', 'ji', idSuffix: 'di'),
  _KanaSource(KanaGroup.dakuten, 'ヅ', 'zu', idSuffix: 'du'),
  _KanaSource(KanaGroup.dakuten, 'デ', 'de'),
  _KanaSource(KanaGroup.dakuten, 'ド', 'do'),
  _KanaSource(KanaGroup.dakuten, 'バ', 'ba'),
  _KanaSource(KanaGroup.dakuten, 'ビ', 'bi'),
  _KanaSource(KanaGroup.dakuten, 'ブ', 'bu'),
  _KanaSource(KanaGroup.dakuten, 'ベ', 'be'),
  _KanaSource(KanaGroup.dakuten, 'ボ', 'bo'),
  _KanaSource(KanaGroup.handakuten, 'パ', 'pa'),
  _KanaSource(KanaGroup.handakuten, 'ピ', 'pi'),
  _KanaSource(KanaGroup.handakuten, 'プ', 'pu'),
  _KanaSource(KanaGroup.handakuten, 'ペ', 'pe'),
  _KanaSource(KanaGroup.handakuten, 'ポ', 'po'),
  _KanaSource(KanaGroup.yoon, 'キャ', 'kya'),
  _KanaSource(KanaGroup.yoon, 'キュ', 'kyu'),
  _KanaSource(KanaGroup.yoon, 'キョ', 'kyo'),
  _KanaSource(KanaGroup.yoon, 'シャ', 'sha'),
  _KanaSource(KanaGroup.yoon, 'シュ', 'shu'),
  _KanaSource(KanaGroup.yoon, 'ショ', 'sho'),
  _KanaSource(KanaGroup.yoon, 'チャ', 'cha'),
  _KanaSource(KanaGroup.yoon, 'チュ', 'chu'),
  _KanaSource(KanaGroup.yoon, 'チョ', 'cho'),
  _KanaSource(KanaGroup.yoon, 'ニャ', 'nya'),
  _KanaSource(KanaGroup.yoon, 'ニュ', 'nyu'),
  _KanaSource(KanaGroup.yoon, 'ニョ', 'nyo'),
  _KanaSource(KanaGroup.yoon, 'ヒャ', 'hya'),
  _KanaSource(KanaGroup.yoon, 'ヒュ', 'hyu'),
  _KanaSource(KanaGroup.yoon, 'ヒョ', 'hyo'),
  _KanaSource(KanaGroup.yoon, 'ミャ', 'mya'),
  _KanaSource(KanaGroup.yoon, 'ミュ', 'myu'),
  _KanaSource(KanaGroup.yoon, 'ミョ', 'myo'),
  _KanaSource(KanaGroup.yoon, 'リャ', 'rya'),
  _KanaSource(KanaGroup.yoon, 'リュ', 'ryu'),
  _KanaSource(KanaGroup.yoon, 'リョ', 'ryo'),
  _KanaSource(KanaGroup.yoon, 'ギャ', 'gya'),
  _KanaSource(KanaGroup.yoon, 'ギュ', 'gyu'),
  _KanaSource(KanaGroup.yoon, 'ギョ', 'gyo'),
  _KanaSource(KanaGroup.yoon, 'ジャ', 'ja'),
  _KanaSource(KanaGroup.yoon, 'ジュ', 'ju'),
  _KanaSource(KanaGroup.yoon, 'ジョ', 'jo'),
  _KanaSource(KanaGroup.yoon, 'ビャ', 'bya'),
  _KanaSource(KanaGroup.yoon, 'ビュ', 'byu'),
  _KanaSource(KanaGroup.yoon, 'ビョ', 'byo'),
  _KanaSource(KanaGroup.yoon, 'ピャ', 'pya'),
  _KanaSource(KanaGroup.yoon, 'ピュ', 'pyu'),
  _KanaSource(KanaGroup.yoon, 'ピョ', 'pyo'),
];
