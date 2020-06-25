import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unofficial_jisho_api/parser.dart' as jisho_parser;

final JsonEncoder encoder = JsonEncoder.withIndent('  ');

const String searchExample = '保護者';
final String searchURI = jisho_parser.uriForPhraseScrape(searchExample);

void main() async {

  await http.get(searchURI).then((result) {
    final parsedResult = jisho_parser.parsePhrasePageData(result.body, searchExample);
    print(encoder.convert(parsedResult));
  });
}