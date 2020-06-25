import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final encoder = JsonEncoder.withIndent('  ');

const SEARCH_EXAMPLE = '保護者';
final SEARCH_URI = jisho_parser.uriForExampleSearch(SEARCH_EXAMPLE);

void main() async {
  await http.get(SEARCH_URI).then((result) {
    final parsedResult = jisho_parser.parseExamplePageHtml(result.body, SEARCH_EXAMPLE);
    print('English: ${parsedResult.results[0].english}');
    print('Kanji ${parsedResult.results[0].kanji}');
    print('Kana: ${parsedResult.results[0].kana}');
  });
}