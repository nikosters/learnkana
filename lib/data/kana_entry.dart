enum KanaScript { hiragana, katakana }

enum KanaGroup { basic, dakuten, handakuten, yoon }

class KanaEntry {
  const KanaEntry({
    required this.id,
    required this.script,
    required this.group,
    required this.kana,
    required this.romaji,
  });

  final String id;
  final KanaScript script;
  final KanaGroup group;
  final String kana;
  final String romaji;
}
