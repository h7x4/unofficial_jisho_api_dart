import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:unofficial_jisho_api/api.dart';

final JsonEncoder encoder = JsonEncoder.withIndent('  ');
final String currentdir = Directory.current.path;

void writeCases(
  Function apiFunction,
  String folderName,
  List<String> queries,
) async {
  final dir = path.join(currentdir, 'test', folderName);

  for (var testCount = 0; testCount < queries.length; testCount++) {
    final result = await apiFunction(queries[testCount]);
    final content = encoder.convert(result);
    final filePath = path.join(dir, '$testCount.json');

    await File(filePath).writeAsString(content);
  }
}

const kanjiQueries = ['車', '家', '楽', '極上', '贄', 'ネガティブ', 'wegmwrlgkrgmg', '水'];
const exampleQueries = ['車', '日本人', '彼＊叩く', '皆', 'ネガティブ', 'grlgmregmneriireg'];
const phraseQueries = ['車', '日本人', '皆', 'ネガティブ', 'grlgmregmneriireg'];

void main() async {
  writeCases(searchForKanji, 'kanji_test_cases', kanjiQueries);
  writeCases(searchForExamples, 'example_test_cases', exampleQueries);
  writeCases(scrapeForPhrase, 'phrase_scrape_test_cases', phraseQueries);
}
