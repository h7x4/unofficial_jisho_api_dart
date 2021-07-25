import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchKanji = '車';
final Uri searchURI = jisho_parser.uriForKanjiSearch(searchKanji);

void main() {
  http.get(searchURI).then((result) {
    final parsedResult =
        jisho_parser.parseKanjiPageData(result.body, searchKanji);
    final data = parsedResult.data;
    if (data != null) {
      print('JLPT level: ${data.jlptLevel}');
      print('Stroke count: ${data.strokeCount}');
      print('Meaning: ${data.meaning}');
    }
  });
}
