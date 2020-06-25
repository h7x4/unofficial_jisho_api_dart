import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchKanji = '車';
final String searchURI = jisho_parser.uriForKanjiSearch(searchKanji);

void main() async {
  await http.get(searchURI).then((result) {
    final parsedResult = jisho_parser.parseKanjiPageData(result.body, searchKanji);
    print('JLPT level: ${parsedResult.jlptLevel}');
    print('Stroke count: ${parsedResult.strokeCount}');
    print('Meaning: ${parsedResult.meaning}');
  });
}