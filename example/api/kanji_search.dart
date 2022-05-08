import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/api.dart' as jisho;

void main() {
  jisho.searchForKanji('語').then((result) {
    print('Found: ${result.found}');

    final data = result.data;
    if (data != null) {
      print('Kanji: ${data.kanji}');
      print('Taught in: ${data.taughtIn}');
      print('JLPT level: ${data.jlptLevel}');
      print('Newspaper frequency rank: ${data.newspaperFrequencyRank}');
      print('Stroke count: ${data.strokeCount}');
      print('Meaning: ${data.meaning}');
      print('Kunyomi: ${jsonEncode(data.kunyomi)}');
      print('Kunyomi example: ${jsonEncode(data.kunyomiExamples[0])}');
      print('Onyomi: ${jsonEncode(data.onyomi)}');
      print('Onyomi example: ${jsonEncode(data.onyomiExamples[0])}');
      print('Radical: ${jsonEncode(data.radical)}');
      print('Parts: ${jsonEncode(data.parts)}');
      print('Stroke order diagram: ${data.strokeOrderDiagramUri}');
      print('Stroke order SVG: ${data.strokeOrderSvgUri}');
      print('Stroke order GIF: ${data.strokeOrderGifUri}');
      print('Jisho Uri: ${data.uri}');
    }
  });
}