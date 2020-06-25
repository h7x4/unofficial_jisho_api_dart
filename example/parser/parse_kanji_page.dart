import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final encoder = JsonEncoder.withIndent('  ');

const SEARCH_KANJI = '車';
final SEARCH_URI = jisho_parser.uriForKanjiSearch(SEARCH_KANJI);

void main() async {
  await http.get(SEARCH_URI).then((result) {
    final parsedResult = jisho_parser.parseKanjiPageData(result.body, SEARCH_KANJI);
    print('JLPT level: ${parsedResult.jlptLevel}');
    print('Stroke count: ${parsedResult.strokeCount}');
    print('Meaning: ${parsedResult.meaning}');
  });
}