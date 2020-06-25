import 'dart:convert' show jsonEncode;
import 'package:unofficial_jisho_api/api.dart' as jisho;

void main() async {
  await jisho.searchForKanji('語').then((result) {
    print('Found: ${result.found}');
    print('Taught in: ${result.taughtIn}');
    print('JLPT level: ${result.jlptLevel}');
    print('Newspaper frequency rank: ${result.newspaperFrequencyRank}');
    print('Stroke count: ${result.strokeCount}');
    print('Meaning: ${result.meaning}');
    print('Kunyomi: ${jsonEncode(result.kunyomi)}');
    print('Kunyomi example: ${jsonEncode(result.kunyomiExamples[0])}');
    print('Onyomi: ${jsonEncode(result.onyomi)}');
    print('Onyomi example: ${jsonEncode(result.onyomiExamples[0])}');
    print('Radical: ${jsonEncode(result.radical)}');
    print('Parts: ${jsonEncode(result.parts)}');
    print('Stroke order diagram: ${result.strokeOrderDiagramUri}');
    print('Stroke order SVG: ${result.strokeOrderSvgUri}');
    print('Stroke order GIF: ${result.strokeOrderGifUri}');
    print('Jisho Uri: ${result.uri}');
  });
}