import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchExample = '保護者';
final Uri searchURI = jisho_parser.uriForExampleSearch(searchExample);

void main() {
  http.get(searchURI).then((result) {
    final parsedResult =
        jisho_parser.parseExamplePageData(result.body, searchExample);
    print('English: ${parsedResult.results[0].english}');
    print('Kanji ${parsedResult.results[0].kanji}');
    print('Kana: ${parsedResult.results[0].kana}');
  });
}
